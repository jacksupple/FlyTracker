import socket
import sys
import traceback
import os
import time

#Send trigger signal to trigger server
def sendTrigger(cmd):

        try:

                s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
                host = '130.238.33.123'
                port = 4444
                s.connect((host,port))

                print 'Connected to: ',s.getpeername(),'... sending ',cmd,' command..'

                s.sendall(cmd[0])

                s.close()        #Close connection when done

        except Exception:
                print 'Couldnt connect to server'
                print traceback.format_exc()

if __name__ == '__main__':

        start = time.time()

        #Set this to any path on your system, its important that this is the same path as the pipe in the visual stimuli software. 
        pipe = '/home/motionvision/pipe'

        #Runs until quit command is recieved from pipe or until time out
        while True and round(time.time()-start) < 120:
                #Reads from pipe
                cmd = open(pipe).read()

                sendTrigger(cmd)

                if cmd[0] == 'q':
                        break 
