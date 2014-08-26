import sys
import threading
import socket
import utilities
import traceback
import time
import os
import json
				
#Global variables
coords = []
coordinates = {"x_1":0,"y_1":0,"x_2":0,"y_2":0,"t":0}
runner = True
mice_ = ['mouse0','mouse1','mouse2','mouse3','mouse4']
defaultPort = 4444 #Default port value for the trigger server to be listening on
pipe = utilities.Utilities.getPath('pipe')

running = True

#Handles the mice sensors, inherits from Thread as it continously polls the coord variable
#which in return is written to by the mice.
class MouseHandler(threading.Thread):
	
	#Default constructor, set up the mouse sensors
	def __init__(self):
		self.sensors = []
		self.triggerMouse = None
		self.mouseIDs = utilities.FileHandler.loadFromFile('mice.txt');
		self.run_ = True
		self.pause = False
		self.start_ = 0
		self.s1 = SensorMouse("sensor1",self.mouseIDs["sensor1"],self)
		self.s2 = SensorMouse("sensor2",self.mouseIDs["sensor2"],self)
		
		super(MouseHandler,self).__init__()
		
	def stop(self):
		self.run_ = False;

	#Overriden run-method, inefficient and should be revisited. Dominated by pointless iterations due
	#to lack of good solution for pausing it from the outside. 
	def run(self):
		global coords
		counter = 0
		temporary = {"x_1":0,"y_1":0,"x_2":0,"y_2":0}

		try:	
			#Daemon threads are all closed (not clean close) when all non-daemon threads are terminated
			self.s1.setDaemon(True)
			self.s2.setDaemon(True)

			#Run the threads			
			self.s1.start()
			self.s2.start()
			
		except Exception:
			utilities.FileHandler.logException(traceback.format_exc())
		
		flag = True #flag for determining whether blockmarker has been added or not
		while self.run_:					
			
			if (coordinates['x_1'] != 0 or coordinates['x_2'] != 0 or coordinates['y_1'] != 0 or coordinates['y_2'] != 0) and not self.pause:
				
				if not flag:
					flag = True
				
				if counter < 2:
					temporary['x_1'] = temporary['x_1']+coordinates['x_1']
					temporary['x_2'] = temporary['x_2']+coordinates['x_2']
					temporary['y_1'] = temporary['y_1']+coordinates['y_1']
					temporary['y_2'] = temporary['y_2']+coordinates['y_2']
					counter += 1
				else:
					temporary['t'] = int(round((time.time()-self.start_)*10000))
					utilities.FileHandler.saveToFile(temporary,'tempdata.txt','append')
					temporary = {"x_1":0,"y_1":0,"x_2":0,"y_2":0}
					counter = 0

				coordinates['x_1'] = 0
				coordinates['x_2'] = 0
				coordinates['y_1'] = 0
				coordinates['y_2'] = 0

			#if self.pause and flag:
			#	utilities.FileHandler.saveToFile('pause','tempdata.txt','append')
			#	flag = False
	
		
	def addMouse(self,mouse):
		self.sensors.append(mouse)


#Super class to the different mouse classes. 
class AbstractMouse(threading.Thread):

	def __init__(self,nr,handler):
		global mice_
		
		self.number = nr
		self.prefix = '/dev/input/'
		self.mouse = None
				
		try:
			str1 = self.prefix + mice_[self.number]
			self.mouse = file(str1)
		except IOError:
			utilities.FileHandler.logException("Mouse "+self.id+" was not found:"+str1)

		super(AbstractMouse,self).__init__()

#Id-mouse used to id itself
class IdMouse(AbstractMouse):

	def __init__(self,nr):
		self.id = -1
		self.run_ = True
		super(IdMouse,self).__init__(nr,None)

	#Simple method to identfiy which mouse is which
	def run(self):
		while self.run_:
			status, dx, dy = tuple(ord(c) for c in self.mouse.read(3))	
			self.id = self.number				
			
#Sensor mouse, provides functions for reading mouse delta coordinates	
class SensorMouse(AbstractMouse):

	def __init__(self,identifier,nr,h):
		self.id = identifier
		self.number = nr
		self.handler = h	
		super(SensorMouse,self).__init__(nr,h)
		
	
	def run(self):
		global coords
		
		try:
			#Reads mouse delta coordinates and write them to the global coord array
			while self.handler.run_:
				status, dx, dy = tuple(ord(c) for c in self.mouse.read(3))
				dx = utilities.Utilities.toSigned(dx)
				dy = utilities.Utilities.toSigned(dy)
					
				if self.id == 'sensor1':
					coordinates["x_1"] = dx
					coordinates["y_1"] = dy
	
				elif self.id == 'sensor2':		
					coordinates["x_2"] = dx
					coordinates["y_2"] = dy

		except Exception:
			utilities.FileHandler.logException(traceback.format_exc())			
			
#Class for handling the network connection
class socketHandler(threading.Thread):

	def __init__(self,p):
		self.port = p
		self.handler = MouseHandler()
		self.handler.setDaemon(True) #Setting thread to daemon means its terminated as all non-threads are terminated

		super(socketHandler,self).__init__()

	def run(self):

		try:
			s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
			
			s.bind(('',self.port)) #Using '' is prefferable compared to IP-address
			s.listen(1)
			#s.settimeout(300)	
			
			print 'connection is running on localhost'
			connection, addr = s.accept()     # Establish connection with client.
			print 'Connection accepted from ',addr
	
			msg = connection.recv(1)
		
			if msg == 's':
				self.handler.start()
				self.handler.start_ = time.time()
				utilities.FileHandler.saveToFile(time.ctime(),'blocktime.txt','append')
			else:
				print 'Not correct msg ',msg
		
		
			#Runs until client process sends 'quit'-command		
			while self.handler.run_:
			
				connection.close()
				connection, addr = s.accept()     # Establish connection with client.
			
				trigger = connection.recv(1)

				print 'Message rec: ',trigger

				if trigger == 'p':
					self.handler.pause = True
					utilities.FileHandler.saveToFile('pause','tempdata.txt','append')
				elif trigger == 'q':
					self.handler.pause = True
					utilities.FileHandler.saveToFile('quit','tempdata.txt','append')	
				elif trigger == 's':
					self.handler.pause = False
					self.handler.start_ = time.time()
					utilities.FileHandler.saveToFile(time.ctime(),'blocktime.txt','append')		
		

		except Exception:
			print traceback.format_exc()
			utilities.FileHandler.logException(traceback.format_exc())	
		finally: 
			s.shutdown(socket.SHUT_RDWR)	
			
			try:
				connection.close()                # Close the connection
			except UnboundLocalError:
				pass


#Listens on socket for signal from trigger client. Can start, pause and stop readings
def runWithNetworkTrigger(args):
	port = int(args['port'])
	
	handler = socketHandler(port)
	
	handler.setDaemon(True)
	handler.start()

	#Reads from pipe as soon as anything is read it stops and all daemon threads are closed aswell
	open(pipe).read().strip()	

#Run DAQ with timer
#Paramter time should be in ms
def runWithTimer(args):
	handler = MouseHandler()

	utilities.FileHandler.saveToFile(time.ctime(),'blocktime.txt','append')
	handler.start()
	handler.start_ = time.time()

	time.sleep(int(args['time'])/1000)

	handler.stop()	
	utilities.FileHandler.saveToFile('kill','tempdata.txt','append')

#Run DAQ without trigger, uses named pipe to communicate with matlab
def runWithoutTrigger(args):
	global pipe, coords

	handler = MouseHandler()
	utilities.FileHandler.saveToFile(time.ctime(),'blocktime.txt','append')
	handler.start()
	handler.start_ = time.time()
	#Reads from pipe as soon as anything is written it stops
	open(pipe).read().strip()
	handler.stop()	

#Function for parsing system args. 
def parseArgs(args):
	output = {}
	output['function'] = args[1]	

	for index in range(2,len(args),2):
		output[args[index]] = args[index+1]
		
	return output

#Code that is run when calling DAQ.py
if __name__ == '__main__':
	#Precondition:
	#System args must be in the form: 'function' 'parameter1' 'value1' 'parameter2' 'value2'...	
	
	#Function map 
	functions = {'network':runWithNetworkTrigger, 'notrigger':runWithoutTrigger, 'timer':runWithTimer}	
	
	args = parseArgs(sys.argv) #sys.argv are arguments provided when calling function from commandline

	#Launch provided function label
	functions[args['function']](args)
