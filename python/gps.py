#!/usr/bin/python
# -*- coding:utf-8 -*-
# sudo chmod 666 /dev/ttyUSB2
# wystawic antene gps za okno
import serial
import time

ser = serial.Serial('/dev/ttyUSB2',115200)
rec_buff = ''
latitude = 0
longitude = 0

def send_at(command,back,timeout):
	global rec_buff
	ser.write((command+'\r\n').encode())
	time.sleep(timeout)
	if ser.inWaiting():
		time.sleep(0.1)
		rec_buff = ser.read(ser.inWaiting())
	if rec_buff != '':
		if back not in rec_buff.decode():
			print(command + ' back: ' + rec_buff.decode())
			return 0
		else:
			print(rec_buff.decode())
			return 1
	else:
		print('GPS is not ready')
		return 0

def NMEAToLongLat(char_buffer):
	global longitude
	global latitude
	parts = str(char_buffer)[13:].split(",")
	latitude = round(float(parts[0][:2]) + (float(parts[0][2:])/60) * (1 if "N" in parts[1] else -1), 6)
	longitude = round(float(parts[2][:3]) + (float(parts[2][3:])/60) * (1 if "E" in parts[3] else -1), 6)
	meters_above_sea = float(parts[6])
	print(f"lat: {latitude}, long: {longitude}, meters: {meters_above_sea}")

def readSerial():
	global rec_buff
	if ser.inWaiting():
		rec_buff = ser.read(ser.inWaiting())
	if rec_buff != '':
		message = rec_buff.decode()
		if "+CGPSINFO:" in message:
    			print(message)
				# NMEAToLongLat(message)

try:
	print('SIM7600X is starting:')
	ser.flushInput()
	print('Start GPS session...')
	send_at('AT+CGPS=1,1','OK',1)
	time.sleep(2)
	send_at('AT+CGPSINFO=1','+CGPSINFO: ',1)
	time.sleep(1)
	while True:
		readSerial()
		time.sleep(1)
except Exception as error:
	print(error)
	send_at('AT+CGPSINFO=0','+CGPSINFO: ',1)	
	ser.close()
except KeyboardInterrupt:
	print(f"http://maps.google.com/maps?f=q&hl=en&q={latitude},{longitude}")
	send_at('AT+CGPSINFO=0','+CGPSINFO: ',1)	
	ser.close()
