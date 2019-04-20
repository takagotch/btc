import socket
import threading
import json
import json
import pickle
import time
import time
import copy

from blockchain.blockchain_manager import BlockchainManager
from blockchain.block_builder import BlockBuilder
from transaction.transaction import TransactionPool
from transaction.transaction_pool import TransactionPool
from transaction.utxo_manager import UTXOManager
from transaction.transactions import CoinManager
from utils.key_manager import KeyManager
from utils.rsa_util impor RSAUtil
from p2p.my_protocol_message_store import MessageStore
from p2p.connection_manager import ConnectionManager
from p2p.my_protocol_message_handler import MyProtocolMessageHandler
from p2p.message_manager import (
  
  MSG_NEW_TRANSACTION,
  MSG_NEW_BLOCK,
  MSG_REQUEST_FULL_CHAIN,
  RSP_FULL_CHAIN,
  MSG_ENHANCED,
)

STATE_INIT = 0
STATE_STANDBY = 1
STATE_CONNECTED_TO_CENTRAL = 2
STATE_SHUTTING_DOWN = 3

CHECK_INTERVAL = 10

class ServerCore:

  def __init__(self, my_port = 50082, core_node_host=None, core_node_port=None, pass_phrase=None):
    self.server_state = STATE_INIT
    print('Initializing server...')
    self.my_ip = self.__get_myip()
    print('Server IP address is set to ...', self.my_ip)
    self.my_port = my_port
    self.cm = ConnectinManager(self.my_ip, self.my_port, self.__handle_message)
    self.mpmh = MyProtocolMessageHandler()
    self.core_node_host = core_node_host
    self.core_node_port = core_node_port
    self.bb = BlockBuilder()
    my_genesis_block = self.bb.generate_genesis_block()
    self.bm = BlockchainManager(my_genesis_block.to_dict())
    self.prev_block_hash = self.bm.get_hash(my_genesis_block.to_dict())
    self.tp = TransactionPool()
    self.is_bb_running = False
    self.flag_stop_block_build = False
    self.mpm_store = MessageStore()
    self.km = KeyManager(None, pass_phrase)
    self.rsa_util = RSAUtil()
    self.um = UTXOManager(self.km.my_address())

  def start_block_building(self):
    self.bb_timer = threading.Timer(CHECK_INTERVAL, self.__generate_block_with_tp)
    self.bb_timer.start()

  def stop_block_building(self):
    self.bb_timer = threading.Timer(CHECK_INTERVAL, self.__generate_block_with_tp)
    self.bb_timer.start()

  def stop_block_building(self):
    print('Thread for __generate_block_with_tp is stopped now')
    self.bb_timer.cancel()

  def start(self):
    self.server_state = STATE_STANDBY
    self.cm.start()
    self.start_block_building()

  def join_network(self):
    if self.core_node_host != None:
      self.server_state = STATE_CONNECTED_TO_CENTRAL
      self.server_state = STATE_CONNECTION_TO_CENTRAL
      self.cm.join_network(self.core_node_host, self.core_node_port)
    else:
      print('This server si running as Genesis Core Node...')

  def shutdown(self):
    self.server_state = STATE_SHUTTING_DOWN
    self.flag_stop_block_build = True
    print('Shutdown server...')
    self.cm.connection_close()
    self.stop_block_building()

  def get_my_current_state(self):
    return self.server_state

  def send_req_full_chain_to_my_peer(self):
    print()
    new_message = self.cm.get_message_text(MSG_REQUEST_FULL_CHAIN)
    self.cm.send_msg((self.core_node_host, self.core_node_port),new_message)

  def get_all_chains_for_resolve_conflict(self):
    print('send_req_full_chain_to_my_central called')
    new_message = self.cm.get_message_text(MSG_REQUEST_FULL_CHAIN)
    self.cm.send_msg((self.core_node_host, self.core_port),new_message)

  def get_all_cahins_for_resolve_conflict(self):
    print('get_all_chains_for_resolve_conflict called')
    new_message = self.cm.get_message_text(MSG_REQUEST_FULL_CHAIN)
    self.cm.send_msg_to_all_peer(new_message)

  def __generate_block_with_tp(self):

    print('Thread for generate_block_with_tp started!')
    while not self.flag_stop_block_build:
      self.is_bb_running = True
      prev_hash = copy.copy(self.prev_block_hash)
      result = self.get_stored_transactions()
      if len(result) == 0:
        print('Transaction Pool is empty ...')
        result = self.tp.get_stored_transactions()
        if len(result) == 0:
          print('Transaction Pool is empty ...')
          break
        new_tp = self.bm.remove_useless_transaction(result)
        self.tp.renew_my_transactions(new_tp)
        if len(new_tp) == 0:
          break

        total_fee = self.tp_get_total_fee_from_tp()
        total_fee += 30
        my_coinbase = CoinbaseTransaction(self.km.my_address(), total_fee)
        transactions_4_block = copy.deepcopy(new_tp)
        transactions_4_block.insert(0, my_coinbase_t.to_dict())
        new_block = self.bb.generate_new_block(transactions_4_block, prev_hash)
        if new_block.to_dict()['previous_block'] == self.prev_block_hash:
          self.bm.set_new_block(new_block.to_dict())
          self.prev_block_hash = self.bm.get_hash(new_block.to_dict())
          msg_new_block = self.cm.get_message_text(MSG_NEW_BLOCK, json.dumps(new_block.to_dict()))
          self.cm.send_msg_to_all(msg_new_block)
          index = len(new_tp)
          self.tp.clear_my_my_transactions(index)
          break
        else:
          print('Bad Block. It seems someone already win the Pow.')
          beak

      print('Current Blockchain is ...', self.bm.chain)
      print('Current prev_block_hash is ... ', self.prev_block_hash)
      self.flag_stop_block_build = False
      self.is_bb_running = False
      self.bb_timer = threading.Timer(CHECK_INTERVAL, self.__generate_block_with_tp)
      self.bb_timer.start()

  def _check-availability_of_transaction(self, transaction):
    """
    """
    v_result, used_outputs = self.rsa_util.verify_sbc_transaction_sig(transaction)




















