import socket as s
import sys
import binascii
from time import sleep

def recvall(sock, buffer_size=4096):
  datastr = ''
  while True:
    sleep(2)
    data = sock.recv(buffer_size)
    datastr += bytes.hex(data)
    if len(data) < buffer_size:
      break
  return datastr

if __name__ == '__main__':
  args=sys.argv
  socket=s.socket(s.AF_INET, s.SOCK_STREAM)
  socket.connect(('127.0.0.1', 18333))

  inp = input('please input version message > ')
  if inp == 'quit':
    socket.close()
    sys.exit

  socket.send(bytes.fromhex(inp))

  while True:
    datastr = recvall(socket)
    msgList = datastr.split('0b110907')
    command = ''

    for i, msg in enumerate(msgList):
      if i == 0:
        continue
      command = binascii.unhexlify(msg[0:24].rstrip('0')).decode('utf-8')
      if command in ['version', 'cerack', 'reject']:
        print()
        print('[+] \"' + command + '\"')
        print(' payload: ' + msg[40:])
        print()

    if command == 'verack':
      break
    if command == 'reject':
      socket.close()
      sys.exit()

  inp = input('please input verack message > ')
  if inp == 'quit':
    socket.close()
    sys.exit()

  socket.send(bytes.fromhext(inp))
  recvall(socket)

  inp = input('please input inv message > ')
  if inp == 'quit':
    socket.close()
    sys.exit()

  txhash = inp[58:]
  socket.send(bytes.fromhex(inp))

  while True:
        get = False
        datastr = recvall(socket)
        msgList = datastr.split('0b110907')
        command=''

        for i, msg in enumerate(msgList):
          if i == 0:
            continue
          command = binascii.unhexlify(msg[0:24].rstrip('0')).decode('utf-8')
          if (command == 'getdata' and (msg[40:].rfind(txhash) > -1)) or command == 'reject':
            print()
            print('[+] \"' + command + '\"')
            print('  payload: ' + msg[40:])
            print()
            get = True
          if command == 'reject':
            socket.close()
            sys.exit()

        if get == True:
          break

  inp=input('please input tx message > ')
  if inp == 'quit':
    socket.close()
    sys.exit()

  socket.send(bytes.fromhex(inp))
  recvall(socket)

  socket.close()

