import os

print(os.uname().sysname == "Linux")

#an OBD command (sensor)
# response = connection.query(cmd) # send the command, and parse the response
# print(response.value) # returns unit-bearing values thank
