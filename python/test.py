import obd, datetime,os

debug_file_path = "/media/rafal/CC/debug_data" # path to file with debug data
if not os.path.isdir(debug_file_path):
    os.mkdir(debug_file_path)
debug_file_path+="/"+str(datetime.datetime.now())[:10]
if not os.path.isdir(debug_file_path):
    os.mkdir(debug_file_path)
debug_file_path+="/"+str(datetime.datetime.now())[11:19].replace(':',"-")+".txt"
open(debug_file_path, 'w').close()

#an OBD command (sensor)
# response = connection.query(cmd) # send the command, and parse the response
# print(response.value) # returns unit-bearing values thank
