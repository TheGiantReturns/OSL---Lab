
import socket
import cv2
import time
import threading
import Tkinter
cam = cv2.VideoCapture(0)

def get_image():
	retval,im = cam.read()
	cv2.imwrite("sendlast.jpg",im)
	return im
        
class thread_get_command(threading.Thread):
        def __init__(self,threadID, threadName, host, port):
                threading.Thread.__init__(self)
                self.threadID = threadID
                self.threadName = threadName
                self.port = port
                self.host = host
        def run(self):
                soc = socket.socket()
                soc.bind((self.host,self.port))
                soc.listen(5)
                while 1:
                        conn,addr = soc.accept()
                        msg = conn.recv(1024)
                        if msg is None or msg == "":
				continue
			if "1" in msg:
				print "Move Up"
			elif "2" in msg:
 				print "Move Down"
			elif "3" in msg:
				print "Move Left"
			elif "4" in msg:
				print "Move Right"
			elif "5" in msg:
				print "Move Stop"
			else:
				print msg
                                               
class thread_send_images(threading.Thread):
        def __init__(self,threadID,threadName,host,port):
                threading.Thread.__init__(self)
                self.threadID = threadID
                self.threadName = threadName
                self.port = port
                self.host = host
        def run(self):
                soc = socket.socket()
                soc.bind((self.host,self.port))
                soc.listen(5)
                while 1:
                        conn,addr = soc.accept()
                        print "In socket accept while: Thread 2"
                        while 1:
                                ret,buf = cv2.imencode('.jpg',get_image())
                                conn.send(bytearray(buf))
                                
host = "192.168.43.141"
port = 2004
portimg = 2005


try:
        thread1 = thread_get_command(1,"Thread-1",host,port)
        #thread2 = thread_send_images(2,"Thread-2",host,portimg)
        thread1.start()
        #thread2.start()
        print "I guess we started both!"
        #thread1.join()
        #thread2.join()
except:
   print "Error: unable to start thread"
