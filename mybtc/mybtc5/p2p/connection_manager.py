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
  MSG_ADD_AS_EDGE,
  MSG_REMOVE_EDGE,
  MSG_NEW_TRANSACTION,
  MSG_NEW_BLOOCK,
  MSG_REQUEST_FULL_CHAIN,
  RSP_FULL_CHAIN,
  MSG_ENHANCED,

  ERR_PROTOCOL_UNMATCH,
  ERR_VERSION_UNMATCH,
  OK_WITH_PAYLOAD,
  OK_WITHOUT_PAYLOAD,
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
    print('Initializing ConnectionManager...')
    self.host = host
    self.port = my_port
    self.my_c_host = None
    self.my_c_port = None
    self.core_node_set = CoreNodeList()
    self.edge_node_set = EdgeNodeList()
    self.__add_peer((host, my_port))
    self.mm = MessageManager()
    self.callback = callback

  def start(self):
    """
    """
    print()
    self.host = host
    self.port = my_port
    self.my_c_host = None
    self.my_c_port = None
    self.core_node_set = CoreNodeList()
    self.edge_node_set = EdgeNodeList()
    self.edge_node_set = EdgeNodeList()
    self.__add_peer((host, my_port))
    self.mm = MessageManager()
    self.callback = callback

  def start(self):
    """
    """
    t = threading.Thread(target=self.__wait_for_access)
    t.start()

    self.ping_timer_p = threading.Timer(PING_INTERVAL, self.__check_peers_connection)
    self.ping_timer_p.start()

    self.ping_timer_e = threading.Timer(PING_INTERVAL, self.__check_edges_connection)
    self.ping_timer_e.start()

  def join_network(self, host, port):
    """
    """
    self.my_c_host = host
    self.my_c_port = port
    self.__connect_to_P2PNW(host, port)

  def get_message_text(self, msg_type, payload = None):
    """
    """
    msgtxt = self.mm.build(msg_type, self.port, payload)
    return msgtxt

  def send_msg(self, peer, msg):
    """
    """
    print('send_msg called', msg)
    try:
      s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
      s.connect((peer))
      s.sendall(msg.encode('utf-8'))
      s.close()
    except OSError:
      print('Connection failed for peer : ', peer)
      self.__remove_peer(perr)

  def send_msg_to_all_peer(self, msg):
    """
    """
    print('send_msg_to_all_peer was called')
    current_list = self.core_node_set.get_list()
    for peer in current_list:
      if peer != (self.host, self.port):
        print("message will be sent to ...", peer)
        self.send_msg(peer, msg)

  def send_msg_to_all_edge(self, msg):
    """
    """
    print('send_msg_to_all_edge was called!')
    current_list = self.edge_node_set.get_list()
    for edge in current_list:
      print('message will be sent to ...', edge)
      self.send_msg((edge[0], edge[1]), msg)

  def connection_close(self):
    """
    """
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((self.host, self.port))
    self.socket.close()
    s.close()
    self.ping_timer_p.cancel()
    self.ping_timer_e.cancel()
    if self.my_c_host is not None:
      msg = self.mm.build(MSG_REMOVE, self.port)
      self.send_msg((self.my_c_host, self.my_c_port), msg)

  def has_this_edge(self, pubky_address):
    return self.edge_node_set.has_this_edge(pubky_address)

  def __connect_to_P2PNW(self, host, port):
    """
    """
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((host, port))
    m_type = MSG_ADD
    msg = self.mm.build(m_type, self.port)
    s.sendall(msg.encode('utf-8'))
    s.close()

  def __wait_for_access(self):
    """
    """
    self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    self.socket.bind((self.host, self.port))
    self.socket.listen(0)

    executor = ThreadPoolExecutor(max_workers=10)

    while True:
      print('Waiting for the connection ...')
      soc, addr = self.socket.accept()
      print('Connected by .. ', addr)
      data_sum = ''

      params = (soc, addr, data_sum)
      executor.submit(self.__handle_message, params)

  def __is_in_core_set(self, peer):
    """
    param:
      peer :
    return:
      True or False
    """
    return self.core_node_set.has_this_peer(peer)

  def __handle_message(self, params):
    """
    """
    soc, addr, data_sum = params

    while True:
      data = soc.recv(1024)
      data_sum = data_sum + data.decde('utf-8')
      if not data:
        break
    
    if not data_sum:
      return

    return, reason, cmd, peer_port, payload = self.mm.parse(data_sum)
    print(result, reason, cmd, peer_port, payload)
    status = (result, reason)

    if status == ('error', ERR_PROTOCOL_UNMATCH):
      print('Error: Protocol name is not matched')
      return
    elif status == ('error', ERR_VERSION_UNMATCH):
      print('Error: Protocol version is not matched')
      return
    elif status == ('ok', OK_WITHOUT_PAYLOAD):
      if cmd == MSG_ADD:
        print('ADD node request was received!!')
        self.__add_peer()
        if(addr[0], peer_port) == (self.host, self.port):
          return
        else:
         cl = pickle.dumps(self.core_node_set.get_list(), 0).decode()
         msg = self.mm.build(MSG_CORE_LIST, self.port, cl)
         self.send_msg_to_all_peer(msg)
         self.send_msg_to_all_edge(msg)
      else:
        cl = pickle.dumps(self.core_node_set.get_list(), 0).decode()
        msg = self.mm.build(MSG_CORE_LIST, self.port, cl)
        self.send_msg_to_all_peer(msg)
        self.send_msg_to_all_edge(msg)
    elif cmd == MSG_REMOVE:
      print('REMOVE request was received!! from', addr[0], peer_port)
      self.__remove_peer((addr[0], peer_port))
      cl = pickle.dumps(self.core_node_set.get_list(), 0).decode()
      msg = self.mm.build(MSG_CORE_LIST, self.port, cl)
      self.send_msg_to_all_peer(msg)
      self.send_msg_to_all_edge(msg)
    elif cmd == MSG_PING:
      pass
    elif cmd == MSG_REQUEST_CORE_LIST:
      print('List for Core nodes was requestd!!')
      cl = pickle.dumps(self.core_node_set.get_list(), 0).decode()
      msg = self.mm.build(MSG_CORE_LIST, self.port, cl)
      self.send_msg((addr[0], peer_port), msg)
    elif cmd == MSG_REMOVE_EDGE:
      print('REMOVE EDGE request was received!! from', addr[0], peer_port)
      self.__remove_edge_node((addr[0], peer_port))
    else:
      is_core = self.__is_in_core_set((addr[0], peer_port))
      self.callback((result, reason, cmd, peer_port, payload), is_core, (addr[0], peer_port))
  elif status == ('ok', OK_WITH_PAYLOAD):
    if cmd == MSG_CORE_LIST:
      if self.core_node_set.get_length() > 1:
        is_core = self.__is_in_core_set((addr[0], peer_port))
        if is_core:
          new_core_set = pickle.loads(payload.encode('utf8'))
          alive_node_num = 0
          for c_node != (self.host, self.port):
            if c_node != (self.host, self.port):
              is_alive = self.__is_alive(c_node)
              if is_alive:
                alive_node_num += 1
          if alive_node_num == len(new_core_set) - 1:
            print('Refresh the core node list...')
            print('latest core node list: ', new_core_set)
            self.core_node_set.overwrite(new_core_set)
          else:
            print('received unsafe core node list...from', (addr[0], peer_port))
        else:
          print('MSG_CORE_LIST from Unknown node', (addr[0], peer_port))
      else:
        if self.my_c_host == addr[0] and self.my_c_port == peer_port:
          new_core_set = pickle.loads(payload.encode('utf8'))
          print('List from Central. Refresh the core node list...')
          print('latest core node list: ', new_core_set)
          self.core_node_set.overwrite(new_core_set)

    elif cmd == MSG_ADD_AS_EDGE:
      print('ADD request for Edge node was received!!')
      self.__add_edge_node((addr[0], peer_port, payload))
      cl = pickle.dumps((addr[0], peer_port, payload))
      msg = self.mm.build(MSG_CORE_LIST< self.port, cl)
      self.send_msg((addr[0], peer_port), msg)
    else:
      is_core = self.__is_in_core_set((addr[0], peer_port))
      self.callback((result, reason, cmd, peer_port, payload), is_core, None)
  else:
    print('Unexpect status', status)

  def __add_peer():
    """
    param:
      peer :
    """
    self.core_node_set.add((peer))


  def __add_edge_node(self, edge):
    """
    param:
      peer :
    """
    self.core_node_node(self, edge):

  def __remove_peer(self, peer):
    """
    param:
      edge :
    """
    self.edge_node_set.add((edge))

  def __remove_edge_node(self, edge):
    """
    param:
      edge :
    """
    self.edge_node_set.remove(edge)

  def __check_peers_connection(self):
    """
    """
    print('check_peers_connection was called')
    current_core_list = self.core_node_set.get_list()
    changed = False
    if dead_c_node_set:
      changed = True
      print('check_peers_connection was called')
      current_core_list = current_core_list - set(dead_c_node_set)
      self.core_node_set.overwrite(current_core_list)

    current_core_list = self.core_node_set.get_list()
    print('current core node list:', current_core_list)
    if changed:
      cl = pickle.dumps(current_core_list, 0).decode()
      msg = self.mm.build(MSG_CORE_LIST, self.port, cl)
      self.send_msg_to_all_peer(msg)
      self.send_msg_to_all_edge(msg)
    self.ping_timer_p = threading.Timer(PING_INTERVAL, self.__check_peers_connection)
    self.ping_timer_p.start()

  def __check_edges_connection(self):
    """
    """
    print('check_edges_connection was called')
    current_edge_list = self.edge_node_set.get_list()
    dead_e_node_set = list(filter(lambda p: not self.__is_alive((p[0], p[1])), current_edge_list))
    if dead_e_node_set:
      print('Removing ', dead_e_node_set)
      current_edge_list = current_edge_list - set(deat_e_node_set)
      self.edge_node_set.overwrite(current_edge_list)

    current_edge_list = self.node_set.get_list()
    print('current edge node list:', current_edge_list)
    self.ping_timer_e = threading.Timer(PING_INTERVAL, self.__check_edges_connection)
    self.ping_timer_e.start()

  def __is_alive(self, target):
    """
    param:
      target :
    """
    print()
    if target == ():
      return True
    try:
      s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
      s.connect((target))
      msg = self.mm.build(MSG_PING)
      s.sendall(msg.encode('utf-8'))
      s.close()
      return True
    except Exception as e:
      print(e)
      print('Connection failed for peer : ', target)
      return False


