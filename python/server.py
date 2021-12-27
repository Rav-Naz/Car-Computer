# Importing the relevant libraries
import websockets, os, asyncio, threading, obd 
from datetime import datetime

# Server data
delay = 500 #ms
PORT = 7890
debug_inputs = 0
max_debug_inputs = 20
debug_mode = True
debug_file_list = []
debug_file_list2 = []
supported_commands = []

# search for debug files
for file in os.listdir("debug_data"):
    if file.endswith(".txt"):
        debug_file_list.append(open("debug_data/" + str(file), 'r+'))

# initialize car data
json_data = {
    "last_send": str(datetime.now())
}

def reveal_supported_pids(bitarray, chunk="A"):
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

def get_file_name(file):
    # return name of given file without extension 
    return str(file.name).split('/')[-1].split('.')[0]

def get_debug_data():
    # read line of each file and send data
    threading.Timer(delay/1000, get_debug_data).start()
    for file in debug_file_list:
        line = file.readline()
        if line != '':
            json_data[get_file_name(file)] = int(str(line))
        else:
            file.seek(0)
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
    global max_debug_inputs
    global debug_inputs
    last_send_time = datetime.strptime(json_data["last_send"], '%Y-%m-%d %H:%M:%S.%f')
    time_diff_milis = (datetime.now() - last_send_time).total_seconds() * 1000
    if time_diff_milis > delay:
        for conn in connected:
            await conn.send(str(json_data))
            print("sended: ", json_data)
        json_data["last_send"] = str(datetime.now())
        # if not debug_mode and debug_inputs < max_debug_inputs:
        #     for key in json_data.keys():
        #         if key != 'last_send':
        #             found = False
        #             file = None
        #             for debug_file in debug_file_list2:
        #                 if get_file_name(debug_file) == key:
        #                     found = True
        #                     file = debug_file
        #                     break
        #             if not found:
        #                 file = open("debug_data/" + str(key) + ".txt", 'w+')#debug_file_list.append()
        #                 debug_file_list2.append(file)
        #             file.write(str(json_data[key])+'\n')
        #         else:
        #             debug_inputs += 1
        # elif debug_inputs == max_debug_inputs:
        #     debug_inputs += 4
        #     print("closing")
        #     for debug_file in debug_file_list2:
        #         debug_file.close()
                        
# A set of connected ws clients
connected = set()

# The main behavior function for this server
async def echo(websocket, path):
    print("A client just connected")
    # Store a copy of the connected client
    connected.add(websocket)
    await send_json_data()
    # Handle incoming messages
    try:
        async for message in websocket:
            print("Received message from client: " + message)
            # Send a response to all connected clients except sender
            for conn in connected:
                if conn != websocket:
                    await conn.send("Someone said: " + message)
    # Handle disconnecting clients 
    except websockets.exceptions.ConnectionClosed as e:
        print("A client just disconnected")
    finally:
        connected.remove(websocket)

if debug_mode:
    print("Debug mode")
    get_debug_data()
else:
    print("Car mode")
    #check commands that car support
    connection = obd.Async(portstr="/dev/rfcomm99", fast=False, timeout=30, baudrate=38400) # same constructor as 'obd.OBD()'
    while not connection.is_connected():
        connection = obd.Async(portstr="/dev/rfcomm99", fast=False, timeout=30, baudrate=38400) # same constructor as 'obd.OBD()'
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