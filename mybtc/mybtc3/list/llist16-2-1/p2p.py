# -*- coding: utf-8 -*-
import socket as s
import sys
import binascii
from time import sleep

def recvall(sock, buffer_size=4096):
    datastr = ''
    while True:
        sleep(2) # ペイロードとがヘッダが別パケットで来ることがあるので、sleep で待つ
        data = sock.recv(buffer_size)
        datastr += bytes.hex(data)
        if len(data) < buffer_size:
            break
    return datastr

if __name__ == '__main__':
    args=sys.argv
    socket=s.socket(s.AF_INET, s.SOCK_STREAM)
    socket.connect(('127.0.0.1',18333)) # TCP で127.0.0.1:18333に接続

    inp = input('please input version message > ') # 標準入力で version メッセージを要求
    if inp == 'quit':
        socket.close()
        sys.exit()

    socket.send(bytes.fromhex(inp)) # 標準入力で受けたメッセージを送信する

    while True:
        datastr = recvall(socket)
        msgList = datastr.split('0b110907')   # マジックバイトでスプリット
        command = ''

        for i, msg in enumerate(msgList):
            if i == 0:
                continue
            command = binascii.unhexlify(msg[0:24].rstrip('0')).decode('utf-8') # ヘッダの command 部分を取得
            if command in ['version', 'verack', 'reject']: # version, verack, reject メッセージを受信した場合のみ出力する
                print()
                print('[+] \"' + command + '\"') # command を出力する
                print('     payload: ' + msg[40:]) # ペイロードを出力する
                print()

        if command == 'verack':
                break
        if command == 'reject':
            socket.close()
            sys.exit()


    inp = input('please input verack message > ') # 標準入力で verack メッセージを要求
    if inp == 'quit':
        socket.close()
        sys.exit()

    socket.send(bytes.fromhex(inp))
    recvall(socket)

    inp = input('please input inv message > ') # 標準入力で inv メッセージを要求
    if inp == 'quit':
        socket.close()
        sys.exit()

    txhash = inp[58:] # トランザクションハッシュを取得
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
            if (command == 'getdata' and (msg[40:].rfind(txhash) > -1)) or command == 'reject': # getdata で送信した inv に対するトランザクションの要求か reject の場合のみ出力する
                print()
                print('[+] \"' + command + '\"')
                print('     payload: ' + msg[40:])
                print()
                get = True
            if command == 'reject':
                socket.close()
                sys.exit()

        if get == True:
            break

    inp=input('please input tx message > ') # 標準入力で tx メッセージを要求
    if inp == 'quit':
        socket.close()
        sys.exit()

    socket.send(bytes.fromhex(inp))
    recvall(socket)

    socket.close()