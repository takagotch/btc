import socket
import threading
import pickle
import codecs
from concurrent.futures import ThreadPoolExecutor

from .core_node_list import CoreNodeList
from .edge_node_list import EdgeNodeList
from .message_manager import (
  
  MessageManager,
  MSG_ADD,
  MSG_REMOVE,
  MSG_CORE_LIST,
  MSG_REQUEST_CORE_LIST,
  MSG_PING,

)

PING_INTERVAL = 10

class ConnectionManager:

  def __init__(self, host, my_port, callaback):
    """
    params:
      host :

      my_port :
      callback :
    """
    print()
    self.host = host
    self.port = my_port
    self.my_c_host = None
    self.my_c_port = None


  def start(self):


















