import os
import json
import time

####EDIT START##########

path = '/home/kristian/' #set to location of FlyTracker folder

####EDIT STOP###########

path_pipe = path+'FlyTracker/data/pipe'
path_data = path+'FlyTracker/data/'
path_temp = path+'FlyTracker/data/tempdata/'

#Class for file input/output handling
class FileHandler:

	def __init__(self,filename):
		
		self.currentFile = path_temp = filename
		self.fileCounter = 1

	def saveToFileRes(self,toSave):
		global path_temp

		#fileName = self.currentFile
		#fname = path_temp+fileName
		
		try:		
			if os.path.getsize(fname) > 500000:			
 				FileHandler.saveToFile('newfile',self.currentFile,'append')
				idx = self.currentFile.find('.')

				predot = self.currentFile[0:idx-1]
				postdot = self.currentFile[idx:len(self.currentFile)]
			
				self.currentFile = predot+str(self.fileCounter)+postdot

				self.fileCounter += 1
				

		except OSError:
			pass

		finally:
			#temp = fileName.find('.')
			#predot = fileName[0:temp-1]
			#temp = self.currentFile.find(predot)
			#self.currentFile = self.currentFile[temp:len(self.currentFile)]
			
			#FileHandler.saveToFile(toSave,self.currentFile,'append')
			
			try:
				f = open(self.currentFile,'append')
				output = json.dumps(toSave)+'\n'
				f.write(output)
	
			except IOError:
				FileHandler.logException('Tried to save to: '+path_temp+self.currentFile)	

	#Method for saving to file, the object to save is converted into a
	#json-string that is then saved to file. To retrieve it it needs to be 
	#converted back to object form using json.loads()
	@staticmethod
	def saveToFile(toSave,fileName,*args):
		e = 'w'
		global path_data

		for arg in args:
			e = arg		
			
		try:
			f = open(path_data+fileName,e)
			output = json.dumps(toSave)+'\n'
			f.write(output)
	
		except IOError:
			FileHandler.logException("Couldnt save to file")
			
	
	#Method for loading from file, provide path to file as input
	#Output is object retrieved from the json-string 
	@staticmethod
	def loadFromFile(fileName,*args):
		global path_data
	
		try:
			f = open(path_data+fileName,'r')
			input_ = f.read()
			obj = json.loads(input_)
		except IOError:
			FileHandler.logException("Couldnt load from file, file missing or path is incorrect")
			obj = None		
		return obj
	
	
	@staticmethod
	def logException(exception_message):
		output = exception_message+' '+time.asctime(time.localtime())
		FileHandler.saveToFile(output,'log.txt','a')


#General utility class with functions for data handling
class Utilities:

	@staticmethod
	def padNumber(number,length):
		newNr = str(number)
		while len(newNr) != length:
			newNr = '0'+newNr	
		return newNr
	
	@staticmethod
	def toSigned(n):
		return n - ((0x80 & n) << 1)

	@staticmethod
	def getPath(arg):
		global path, path_pipe
		if arg == 'pipe':
			return path_pipe
		elif arg == 'data':
			return path_data
