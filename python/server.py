# importing the relevant libraries
import websockets, asyncio, threading, obd, json
from datetime import datetime

# server data
delay = 500 # interval of refresh car info (in ms)
PORT = 7890 # server port
debug_mode = True # running mode
debug_file_path = "E:/debug_data.txt" # path to file with debug data
debug_max_inputs = 100 # maximum count of data rows in debug file
debug_position = 0 # current line of debug file
supported_commands = [] # list of supported commands by this car
connection = None # declaration of connection to bluetooth OBD

# initialize car data
json_data = {
    "last_send": str(datetime.now())
}

def reveal_supported_pids(bitarray, chunk="A"):
    # serach for supported commands in this car
    iterator = 0
    offset = 0
    if chunk == "B":
        offset = 32
    elif chunk == "C":
        offset = 64
    for bit_index in range(len(bitarray) - (1 if chunk == "C" else 0)):
        iterator += 1
        if bitarray[bit_index] == "1":
            supported_command = obd.commands[1][iterator+offset]
            supported_commands.append(supported_command)

def get_debug_data():
    # read line of each file and send data
    global json_data
    global debug_position
    global delay
    threading.Timer(delay/1000, get_debug_data).start() # sends debug data every n seconds
    with open(debug_file_path, 'r+') as file_object:
        lines = file_object.readlines()
        temp_last_send = json_data["last_send"]
        json_data = json.loads(lines[debug_position%len(lines)])
        debug_position=debug_position%len(lines)+1
        json_data["last_send"] = temp_last_send
        loop = asyncio.new_event_loop()
        asyncio.set_event_loop(loop)
        loop.run_until_complete(send_json_data())

def new_async_value(response):
    # manage new value from OBD2
    if not response.is_null():
        json_data[response.command] = response.value.magnitude
        loop = asyncio.new_event_loop()
        asyncio.set_event_loop(loop)
        loop.run_until_complete(send_json_data())

async def send_json_data():
    # send new data to all clients
    global debug_max_inputs
    # firewall to prevent too frequent sending of data
    last_send_time = datetime.strptime(json_data["last_send"], '%Y-%m-%d %H:%M:%S.%f')
    time_diff_milis = (datetime.now() - last_send_time).total_seconds() * 1000
    if time_diff_milis > delay: # if last send data is longer than a specified delay
        json_data["last_send"] = str(datetime.now())
        for conn in connected: # for every connected client
            await conn.send(str(json_data))
            print("sended: ", json_data)
        if not debug_mode: # save data to debug data
            with open(debug_file_path, "r+") as file_object:
                debug_lines_count = len(file_object.readlines())
                if debug_lines_count < debug_max_inputs:
                    temp_json = json_data.copy()
                    temp_json.pop("last_send", None)
                    file_object.write(json.dumps(temp_json) + str('\n'))
                        
connected = set() # set of connected ws clients

# main function for this server
async def echo(websocket, path):
    print("A client just connected")
    connected.add(websocket) # Store a copy of the connected client
    await send_json_data()
    try: # Handle incoming messages
        async for message in websocket:
            print("Received message from client: " + message)
            for conn in connected: # Send a response to all connected clients except sender
                if conn != websocket:
                    await conn.send("Someone said: " + message)
    except websockets.exceptions.ConnectionClosed as e: # Handle disconnecting clients
        print("A client just disconnected")
    finally:
        connected.remove(websocket)

if debug_mode:
    print("Debug mode")
    get_debug_data()
else:
    print("Car mode")
    open(debug_file_path, 'w').close()
    # connect to car by bt serial adapter
    connection = obd.Async(portstr="/dev/rfcomm99", fast=False, timeout=30, baudrate=38400) # same constructor as 'obd.OBD()'
    while not connection.is_connected():
        connection = obd.Async(portstr="/dev/rfcomm99", fast=False, timeout=30, baudrate=38400) # same constructor as 'obd.OBD()'
    #check commands that car support
    for chunk in ["A","B","C"]:
        #check support via OBD
        bitarray = "11111111111111111111111111111110"
        reveal_supported_pids(bitarray,chunk)
        if bitarray[-1] == "0":
            break
    for command in supported_commands:
        connection.watch(command, callback=new_async_value)
    connection.start()

# Start the server
start_server = websockets.serve(echo, "localhost", PORT)
print("Server listening on Port " + str(PORT))
asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()