# 1 - Import library
import pygame
from pygame.locals import *
import socket
import time

# 1.5 - Initiallising socket

host = "192.168.43.141"
port = 2004
portimg = 2005
soc = socket.socket()
soc.bind((host,port))
soc.listen(5)
#socimg = socket.socket()
#socimg.bind((host,portimg))
#socimg.listen(5)
#connimg,addr = socimg.accept()
                        
# 2 - Initialize the game
pygame.init()
width, height = 640, 480
screen=pygame.display.set_mode((width, height))
keys = [False, False, False, False]
playerpos=[100,100]

def Capture(size): # (tuple)
	image = pygame.Surface(size)  # Create image surface
	image.blit(screen,(0,0),((playerpos[0],playerpos[1]),size))  # Blit portion of the display to the image
	data = pygame.image.tostring(image,'RGBA')
	return bytearray(data)

# 3 - Load images
player = pygame.image.load("resources/images/mainicon.jpg")
player = pygame.transform.scale(player,(200,200))
# 4 - keep looping through
while 1:
	# 5 - clear the screen before drawing it again
	screen.fill(0)
	# 6 - draw the screen elements
	screen.blit(player, playerpos)
	#connimg.send(Capture((100,100)))
	# 7 - update the screen
	pygame.display.flip()
	conn,addr = soc.accept()
	msg = conn.recv(1024)
	if msg is None or msg == "":
		continue
    	if "1" in msg:
		playerpos[1]-=5
    	elif "2" in msg:
		playerpos[1]+=5
    	elif "3" in msg:
		playerpos[0]-=5
    	elif "4" in msg:
		playerpos[0]+=5
    	elif "5" in msg:
		print "Move Stop"
    	else:
		print msg 
