from tkinter import *
from tkinter import messagebox
from tkinter import filedialog
from tkinter.ttk import Button, Style
from tkinter import ttk
import binascii
import os
import json
import sys
import base64
import datatime
import pprint
import copy

from core.client_core import ClientCore as Core
from transaction.transactions import Transaction
from transaction.transactions import CoinbaseTransaction
from transaction.transactions import TransactionInput
from transaction.transactions import TransactionOutput
from transaction.transactions import EngravedTransaction
from transaction.transactions import UTXOManager as UTXM
from utils.key_manager import KeyManager
from utils.rsa_util import RSAUtil
from utils.aes_util import AESUtil
from p2p.message_manager import (
  
  MSG_NEW_TRANSACTION,
  MSG_ENHANCED,
)

class SimpleBC_Gui(Frame):
  
  def __init__(self, parent, my_port, c_host, c_port):
    Frame.__init__(self, parent):
    self.parent = parent
    self.parent.protocol('WM_DELETE_WINDOW', self.quit)
    self.coin_balance = StringVar(self.parent, '0')
    self.status_message = StringVar(self.parent, 'Ready')
    self.c_core = None
    self.initApp(my_port, c_host, c_port)
    self.setupGUI()

  def quit(self, event=None):
    """
    """
    self.c_core.shutdown()
    self.parent.destroy()

  def initApp(self, my_port, c_host, c_port):
    """
    """
    print('SimpleBitcoin client is now activating ...: ')

    self.km = KeyManager()
    self.um = UTCM(self.km.my_address())
    self.rsa_util = RSAUtil()

    self.c_core = Core(my_port, c_host, c_port, self.update_callback, self.get_message_callback)
    self.c_core.start(self.km.my_address())

    t1 = CoinbaseTransaction(self.km.my_address())
    t2 = CoinbaseTransaction(self.km.my_address())
    t3 = CoinbaseTransaction(self.km.my_address())

    transactions = []
    transactions.append(t1.to_dict())
    transactions.append(t2.to_dict())
    transactions.append(t3.to_dict())
    self.um.extract_utxos(transactions)

    self.update_balance()

  def display_info(self, title, info):
    """
    """
    f = Tk()
    label = Lable(f, text=title)
    label.pack()
    info_area = Text(f, width=70, height=50)
    info_area.insert(INSERT, info)
    info_area.pack()

  def get_mesage_callback(self, target_message):
    print('get_message_callback called!')
    if target_message['message_type'] == 'cipher_message':
      try:
        encrypted_key = base64.bb64ecode(binascii.unhexlify(target_message['enc_key']))
        print('encrypted_key : ', encrypted_key)
        desrypted_key : self.km.decrypt_with_private_key(encrypted_key)
        print('decrypted_key : ', banascii.hexlify(decrypted_key).decode('ascii'))
        #sender = binacii.unhexlify(target_message['sender'])
        aes_util = AESUtil()
        decrypted_message = aes_util.decrypt_with_key(base64.b64decode(binascii.unhexlify(target_message['body'])), decrypted_key)
        print(decrypted_message.decode('utf-8'))
        """
        message = {
          'from' : sender,
          'message' : decrypted_message.decode('utf-8')
        }
        message_4_desplay = pprint.pformat(message, indent=2)
        """
        messagebox.showwarning('You received an instant encrypted message !', decrypted_message.decode('utf-8'))
      except Exception as e:
        print(e, 'error occurred')
    elif target_message['message_type'] == 'engraved':
      sender_name = target_message['sender_alt_name']
      msg_body = base64.b64decode(binascii.unhexlify(target_message['message'])).decode('utf-8')
      timestamp = datetime.datetime.fromtimestamp(int(target_message['timestamp']))
      messagebox.showwarning('You received a new engraved message!', '{} :\n {} \n {}'.format(sender_name, msg_body, timestamp))
  def update_callback(self):
    print('update_callback was called!')
    s_transaction = self.c_core.get_stored_transactions_from_bc()
    print(s_transactions)
    self.um.extract_utxos(s_transactions)
    self.update_balance()

  def update_status(self, info):
    """
    """
    self.status_message.set(info)

  def update_balance():

  def create_menu():


  def show_my_address():

  def show_input_dialog_for_key_loading(self):

def main(my_port, c_host, c_port):

  root = Tk()
  app = SimpleBC_Gui(root, my_port, c_host, c_port)
  root.mainloop()

if __name__ == '__main__':
  args = sys.argv

  if len(args) == 4:
    my_port = int(args[1])
    c_host = args[2]
    c_port = int(args[3])
  else:
    print('Param Error')
    print('$ Wallet_App.py <my_port> <core_ip_address> <core_node_port_num>')
    quit()

  main(my_port, c_host, c_port)







