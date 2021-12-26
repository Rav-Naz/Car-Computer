#00:1D:A5:68:98:8A
import obd
import time

rpm_data = open('debug_data/rpm.txt', 'w+')
speed_data = open('debug_data/speed.txt', 'w+')
obd.logger.setLevel(obd.logging.DEBUG)
connection = obd.Async(portstr="/dev/rfcomm99", fast=False, timeout=30, baudrate=38400) # same constructor as 'obd.OBD()'
# a callback that prints every new value to the console
def new_rpm(r):
    rpm_data.write(str(r).split(' ')[0]+'\n')

def new_speed(r):
    speed_data.write(str(r).split(' ')[0]+'\n')

connection.watch(obd.commands.RPM, callback=new_rpm)
connection.watch(obd.commands.SPEED, callback=new_speed)
connection.start()

# the callback will now be fired upon receipt of new values
time.sleep(300)
speed_data.close()
rpm_data.close()
connection.stop()