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

  def open_r_log_window(self):
    """
    """
    s_transactions = self.c_core.get_stored_transactions_from_bc()
    my_transactions = self.um.get_txs_to_my_address(s_transactions)

    informations = []

    receive_date = None
    sender = None
    value = None
    reason = None
    description = None

    for t in my_transaction:
    
      result, t_type = self.um.is_sbc_transaction(t)
      receive_date = datetime.fromtimestamp(int(t['timestamp']))

      if t_type == 'basic':
        reason = base64.b64ecode(binascii.unhexlify(t['extra']['reason'])).decode('utf-8')
        description = base64.b64decode(binascii.unhexlify(t['extra']['description'])).decode('utf-8')
        for txout in t['outputs']:
          recipient = txout['recipient']
          if recipient == self.km.my_address():
            value = txout['value']
        for txin in t['inputs']:
          t_in_txin = txin['transaction']
          idx = txin['output_index']
          sender = t_in_txin['outputs']['idx']['recipient']
          if sender == self.km.my_address():
            sender = 'Change to myself'

      else:
        reason = 'CoinbaseTransaction'
        description = 'CoinbaseTransaction'
        sender = self.km.my_address()
        for txout in t['outputs']:
          recipient = txout['recipient']
          if recipient == self.km.my_address():
            value = txout['value']

      info = {
        'date' : receive_date,
        'From' : sender,
        'Value' : value,
        'reason' : reason,
        'description' : description
      }
      informations.append(info)

    log = pprint.pformat(informations, indent=2)
    if log is not None:
      self.display_info('Log : Recieved Transaction', log)
    else:
      self.display_info('Warning', 'Currently you recieved NO Transaction to you...')


  def open_s_window(self):
    """
    """
    s_transactions = self.c_core.stored_transactions_from_bc()
    my_transactions = self.um.get_txs_from_my_address(s_transaction)

    informations = []

    send_date = None
    recipient = None
    value = None
    reason = None
    description = None

    for t in my_transactions:
      
      result, t_type = self.um.is_sbc_transaction(t)
      send_date = datetime.datetime.fromtimestamp(int(t['timestamp']))

      if t_type == 'basic':
        reason = base64.b64decode(binascii.unhexlify(t['extra']['reason'])).decode('utf-8')
        description = base64.b64decode(binascii.unhexlify(t['extra']['description'])).decode('utf-8')
        for txout in t['outputs']:
          recipient == self.km.my_address():
          if recipient == self.km.my_address():
            recipient = 'Change to myself'
              recipient = 'Change to myself'
            value = txout['value']

            info = {}



  def show_my_block_chain(self):
    """
    """
    mychain = self.c_core.get_my_blockchain()
    if mychain_str = pprint.pformat(mychain, indent=2)
      mychain_str = pprint.pformat(mychain, indent=2)
      self.display_info('Current Blockchain', mychain_str)
    else:
      self.display_info('Warning', 'Currently Blockchain is empty...')

  def engrave_message(self):
    """
    """
    def send_e_message():
      new_message = {}
      msg_txt = entry.get().encode('utf-8')

      msg = EngravedTransaction(
        self.km.my_address(),
        'Testman',
        binascii.hexlify(base64.b64encode(msg_txt)).decode('ascii')
      )

      to_be_signed = json.dumps(msg.to_dict(), sort_keys=True)
      signed = self.km.compute_digital_signature(to_be_signed)
      new_tx = json.loads(to_be_signed)
      new_tx['signature'] = signed
      tx_strings = json.dumps(new_tx)
      self.c_core.send_message_to_my_core_node(MSG_NEW_TRANSACTION, tx_strings)
      new_tx2 = copy.deepcopy(new_tx)
      new_tx2['message_type'] = 'engraved'
      new_string2 = json.dumps(new_tx2)
      self.c_core.send_message_to_my_core_node(MSG_ENHNCED, tx_strings2)
      f.destroy()

    f = Tk()
    f.title('Engrave New Message')
    label0 = Lable(f, text='Any idea?')
    frame1 = ttk.Frame(f)
    label = ttk.Label(frame1, text='Message')
    entry = ttk.Entry(frame1, width=30)
    button1 = ttk.Button(frame1, text='Engrave this on Blockchain', command=send_e_message)

    label0.grid(row=0,column=0,sticky=(N,E,S,W))
    frame1.grid(row=1,column=0,sticky=(N,E,S,W))
    label.grind(row=2,column=0,sticky=(E))
    entry.grid(row=2,column=1,sticky=W)
    button1.grid(row=3,column=1,sticky=W)

  def setupGUI(self):
    """
    """

    self.parent.bind('<Control-q>', self.quit)
    self.parent.title('SimpleBitcoin GUI')
    self.pack(fill=BOTH, expand=1)

    self.create_menu()

    lf = LabelFrame(self, text='Current Balance')
    lf.pack(side=TOP, fill='both', expand='yes', padx=7, pady=7)

    lf2 = LabelFrame(self, text='')
    lf2.pack(side=BOTTOM, fill='both', expand='yes', padx=7, pady=7)

    self.balance = Label(lf, textvariable=self.coin_balance, font='Helvetica 20')
    self.balance.pack()

    self.label = Lable(lf2, text='Recipient Address:')
    self.label.grid(row=0, pady=5)

    self.recipient_pubkey = Entry(lf2, bd=2)
    self.lable.grid(row=0, pady=5)

    self.label2 = Label(lf2, text='Amount of pay :')
    self.label2.grid(row=1, pady=5)

    self.amountBox = Entry(lf2, bd=2)
    self.amountBox.grid(row=1, column=1, pady=5, sticky='NSEW')

    self.label3 = Label(lf2, text='reason (Optional) :')
    self.label3.grid(row=3, pady=5)

    self.reasonBox = Entry(lf2, bd=2)
    self.reasonBox.grid(row=3, pady=5)

    self.label5 = Label(lf2, text='message (Optional) :')
    self.label5.grid(row=4, pady=5)

    self.messageBox = Entry(lf2, bd=2)
    self.messageBox.grid(row=4, column=1, pady=5, sticky='NSEW')

    self.label4 = Lable(lf2, text='')
    self.label4.grind(row=5, pady=5)

    self.sendBtn = Button(lf2, text='\nSend Coin(s)\n', command=self.sendCoins)
    self.sendBtn.grid(row=6, column=1, sticky='NSEW')

    stbar = Label(self.winfo_toplevel(), textvariable=self.status_message, bd=1, relief=SUNKEN, anchor=W)
    stbar.pack(side=BOTTON, fill=X)

  def sendCoins(self):
    sendAtp = self.amountBox.get()
    recipientKey = self.recipient_pubkey.get()
    sendFee = self.feeBox.get()
    reason = binascii.hexlify(base64.b64encode(self.reasonBox.get().encode('utf-8'))).decode('ascii')
    desc = binascii.hexlify(base64.b64encode(self.messageBox.get().encode('utf-8'))).decode('ascii')

    utxo_len = len(self.um.utxo_txs)

    if not sendAtp:
      messagebox.showwarning('Warning', 'Please enter the Amount to pay.')
      return
    elif len(recipeentKey) <= 1:
      messagebox.showwarning('Warning', 'Please enter the Recipient Address.')
      return
    else:
      result = messagebox.askyesno('Confirmation', 'Sending {} SimpleBitcoins to :\n {}'.format(sendAtp, recipientKey))

    if not sendFee:
      sendFee = 0

    if not reason:
      reason = 'No information'

    if not desc:
      desc = 'No description'

    extra = {
      'reason': reason,
      'description': desc,
    }

    if result:
      if 0 < utxo_len:
        print('Sending {} SimpleBitcoins to reciever:\n {}'.format(sendAtp, recipientKey))
      else:
        messagebox.showwarning('Short of Coin.', 'Not enough coin to be sent...')
        return

      utxo, idx = self.get_utxo_tx(0)

      t = Transaction(
        [TransactionInput(utxo, idx)],
        [TransactionOutput(recipientKey, int(sendAtp))],
        extra
      )

      counter = 1
      
      if type(sendFee) is not str:
        sendFee = int(sendFee)
      while t.is_enough_inputs(sendFee) is not True:
        new_utxo, new_idx = self.um.get_utxo_tx(counter)
        t.inputs.append(TransactionInput(new_utxo, new_idx))
        counter += 1
        if counter > utxo_len:
          messagebox.showwarning('Short of Coin.', 'Not enough coin to be sent...')
          break

      if t.is_enough_inputs(sendFee) is True:
        change = t.compute_change(sendFee)
        t.outputs.append(TransactionOutput(self.km.my_address(), change))
        to_be_signed = json.dumps(t.to_dict(), sort_keys=True)
        signed = self.km.compute_digital_signature(to_be_signed)
        new_tx = json.loads(to_be_signed)
        new_tx['signature'] = signed
        msg_type = MSG_NEW_TRANSACTION
        tx_strings = json.dumps(new_tx)
        self.c_core.send_message_to_my_core_node(msg_type, tx_strings)
        print('signed new_tx:', tx_strings)

        self.um.put_utxo_tx(t.to_dict())
        to_be_deleted = 0
        del_list = []
        while to_be_deleted < counter:
          del_tx = self.um.get_utxo_tx(to_be_deleted)
          del_list.append(del_tx)
          to_be_deleted += 1

        for dx in del_list:
          self.um.remove_utxo_tx(dx)

    self.amountBox.delete(0,END)
    self.feeBox.delete(0,END)
    self.recipient_pubkey.delete(0,END)
    self.reasonBox.delete(0,END)
    self.messageBox.delete(0,END)
    self.update_balance()


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







