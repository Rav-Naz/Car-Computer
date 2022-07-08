# importing the relevant libraries
import websockets, asyncio, threading, obd, json, time, os, serial
from datetime import datetime
obd.logger.setLevel(obd.logging.DEBUG)
# server data
delay = 500 # interval of refresh car info (in ms)
PORT = 7890 # server port
debug_mode = True # running mode
#### DEBUG CONFIG ####
read_debug_file = "/2022-04-03/12-48-38.txt"
base_debug_file_path = "/media/rafal/CC/debug_data" if os.uname().sysname == "Linux" else "E:/debug_data" # path to file with debug data
save_debug_file_path = base_debug_file_path # path to file with debug data
if not os.path.isdir(save_debug_file_path):
    os.mkdir(save_debug_file_path)
save_debug_file_path+="/"+str(datetime.now())[:10]
if not os.path.isdir(save_debug_file_path):
    os.mkdir(save_debug_file_path)
save_debug_file_path+="/"+str(datetime.now())[11:19].replace(':',"-")+".txt"
debug_max_inputs = 600 # maximum count of data rows in debug file
debug_position = 0 # current line of debug file
#######################
connection = None # declaration of connection to bluetooth OBD
whitelist_commands = [ # watched commands (more on: https://python-obd.readthedocs.io/en/latest/Command%20Tables/)
    obd.commands.RPM,
    obd.commands.SPEED,
    obd.commands.ELM_VOLTAGE,
    obd.commands.GET_DTC
]
# GPS configuration
ser = serial.Serial('/dev/ttyUSB2',115200)
rec_buff = ''

# initialize car data
json_data = {
    "last_send": str(datetime.now())
}

def send_at(command,back,timeout):
    global rec_buff
    ser.write((command+'\r\n').encode())
    time.sleep(timeout)
    if ser.inWaiting():
        rec_buff = ser.read(ser.inWaiting())
    if rec_buff != '':
        if back not in rec_buff.decode():
            # print(command + ' back: ' + rec_buff.decode())
            return 0
        else:
            # print(rec_buff.decode())
            return 1
    else:
        print('GPS is not ready')
        return 0

def NMEAToLongLat(char_buffer):
    parts = str(char_buffer)[13:].split(",")
    latitude = round(float(parts[0][:2]) + (float(parts[0][2:])/60) * (1 if "N" in parts[1] else -1), 6)
    longitude = round(float(parts[2][:3]) + (float(parts[2][3:])/60) * (1 if "E" in parts[3] else -1), 6)
    json_data["latitude"] = latitude
    json_data["longitude"] = longitude
	# print(f"lat: {latitude}, long: {longitude}, meters: {meters_above_sea}")

def readSerial():
	global rec_buff
	if ser.inWaiting():
		rec_buff = ser.read(ser.inWaiting())
	if rec_buff != '':
		message = rec_buff.decode()
		if "+CGPSINFO:" in message:
				NMEAToLongLat(message)

def get_debug_data():
    # read line of each file and send data
    global json_data
    global debug_position
    global delay
    threading.Timer(delay/1000, get_debug_data).start() # sends debug data every n seconds
    with open(base_debug_file_path + read_debug_file, 'r+') as file_object:
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
        json_data[str(response.command)[9:].strip().replace(" ","_").lower()] = response.value.magnitude if (str(type(response.value)) == "<class 'pint.unit.build_quantity_class.<locals>.Quantity'>") else str(response.value)
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
        readSerial()
        for conn in connected: # for every connected client
            await conn.send(str(json_data))
            print("sended: ", json_data)
        if not debug_mode: # save data to debug data
            with open(save_debug_file_path, "r+") as file_object:
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

####### MAIN #######
try:
    print('SIM7600X is starting:')
    ser.flushInput()
    print('Start GPS session...')
    send_at('AT+CGPS=1,1','OK',1)
    time.sleep(2)
    send_at('AT+CGPSINFO=1','+CGPSINFO: ',1)
    time.sleep(1)
    if debug_mode:
        print("Debug mode")
        get_debug_data()
    else:
        print("Car mode")
        open(save_debug_file_path, 'w').close()
        # connect to car by BT serial adapter
        print("Waiting for connection...")
        connection = obd.Async(portstr="/dev/rfcomm99", baudrate="9600", fast=False, timeout="10", check_voltage=False, protocol="6") # same constructor as 'obd.OBD()'
        while(len(connection.supported_commands) < 10):
            time.sleep(1)
            connection = obd.Async(portstr="/dev/rfcomm99", baudrate="9600", fast=False, timeout="10", check_voltage=False, protocol="6") # same constructor as 'obd.OBD()'
        print("CONNECTED!")
        print("Supported commands:")
        print(connection.supported_commands)
        for command in whitelist_commands:
            if connection.supports(command):
                connection.watch(command, callback=new_async_value)
        connection.start()

    # Start the server
    start_server = websockets.serve(echo, "localhost", PORT)
    print("Server listening on Port " + str(PORT))
    asyncio.get_event_loop().run_until_complete(start_server)
    asyncio.get_event_loop().run_forever()
except Exception as error:
	print(error)
	send_at('AT+CGPSINFO=0','+CGPSINFO: ',1)	
	ser.close()
except KeyboardInterrupt:
    print("Closing...")
    send_at('AT+CGPSINFO=0','+CGPSINFO: ',1)	
    ser.close()