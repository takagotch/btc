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


