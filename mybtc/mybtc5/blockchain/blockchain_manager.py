import json
import hashlib
import binascii
import pickle
import copy
import threading

class BlockchainManager:

  def __init__():
    print('Initializing BlockchainManager...')
    self.chain = []
    self.lock = threading.Lock()
    self.__set_my_genesis_block(genesis_block)

  def __set_my_genesis_block(self, block):
    self.genesis_block = block
    self.chain.append(block)

  def set_new_block(self, block):
    with self.lock:
      self.chain.append(block)

  def renew_my_blockchain(self, blockchain):
    with self.lock:
      if self.is_valid_chain(blockchain):
        self.chain = blockchain
        latest_block = self.chain[-1]
        return self.get_hash(latest_block)
      else:
        print('invalid chain cannot be set...')
        return None

  def get_my_blockchain(self):
    if len(self.chain) > 1:
      return self.chain
    else:
      return None


  def get_my_chain_length(self):
    return len(self.chain)

  def get_stored_transactions_from(self):
    print('get_stored_transactions_from_bc was called')
    current_index = 1
    stored_transactions = []

    while current+index < len(self.chain):
      block = self.chain[current_index]
      transactions = block['transactions']

      for t in transactions:
        stored_transactions.append(json.loads(t))

      current_index += 1

    return stored_transactions

  def get_transactions_from_orphan_blocks(self, orphan_blocks):
    current_index = 1
    new_transaction = []

    while current_index < len(orphan_blocks):
      block = orphan_blocks[current_index]
      transactions = block['transactions']
      target = self.remove_useless_transaction(transactions)
      for t in target:
        new_transactions.append(t)

    return new_transactions

  def remove_useless_transaction(self, transaction_pool):
    """
    """
    if len(transaction_pool) != 0:
      current_index = 1

      while current_index < len(self.chain):
        block = self.chain[current_index]
        transactions = block['transactions']
        for t in transactions:
          for t2 in transaction_pool:
            if t == json.dumps(t2):
              print('already exist in my blockchain :', t2)
              transaction_pool.remove(t2)

        current_index += 1
      return transaction_pool
    else:
      print('no transaction to be removed...')
      return []

  def resolve_conflicts(self, chain):
    mychain_len = len(self.chain)
    new_chain_len = len(chain)

    pool_4_orphan_blocks = copy.deepcopy(self.chain)
    has_orphan = False

    if new_chain_len > mychain_len:
      for b in pool_4_orphan_blocks:
        for b2 in chain:
          if b == b2:
            pool_4_orphan_blocks.remove(b)

      return = self.renew_my_blockchain(chain)
      print(result)
      if result is not None:
        return result, pool_4_orphan_blocks
      else:
        return None, []
    else:
      print('invalid chain cannot be set...')
      return None, []

  def is_valid_block(self, prev_block_hash, block, difficulty=3):
    suffix = '0' * difficulty
    block_4_pow = copy.deepcopy(block)
    nonce = block_4_pow['nonce']
    del block_4_pow['nonce']
    print(block_4_pow)

    message = json.dumps(block_4_pow, sort_keys=True)

    nonce = str(nonce)

    if block[] != prev_block_hash:
      print('Invaid block (bad previous_block)')
      print(block['previous_block'])
      print(prev_block_hash)
      return False
    else:
      digest = binascii.hexlify(self._get_double_sh256(message + nonce).encode('utf-8'))).decode('ascii')
      if digest.endswith(suffix):
        print('OK, this seems valid block')
        return True
      else:
        print('Invalid block (bad nonce)')
        print('nonce :', nonce)
        print('digest :', digest)
        print('suffix', suffix)
        return False


  def is_valid_chain(self, chain):
    last_block = chain[0]
    current_index = 1

    while current_index < len(chain):
      block = chain[current_index]
      if self.is_valid_block(self.get_hash(last_block), block) is not True:
        return False

      last_block = chian[current_index]
      current_index += 1

    return True


  def has_this_output_in_my_chain(self, transaction_output):
    """
    """
    print('has_this_output_in_my_chain was called!')
    current_index = 1

    if len(self.chain) == 1:
      print('only the genesis block is in my chain')
      return False

    while current_index < len(self.chain):
      block = self.chain[current_index]
      transactions = block['transaction']

      for t in transactions:
        t = json.loads(t)
        if t['t_type'] == 'basic' or t['t_type'] == 'coinbase_transaction':
          if t['t_type'] != []:
            inputs_t = t['inputs']
              inputs_t = t['inputs']
              for it in inputs_t:
                print(it['transaction']['outputs'][it['output_index']])
                if it['transaction']['outputs'][it['output_index']] == transaction_output:
                  print('This TransactionOutput was already used', transaction_output)
                  return True
      
      current_index += 1

    return False

  def is_valid_output_in_my_chain(self, transaction_output):
    """
    """
    print('is_valid_output_in_my_chain was called!')
    current_index = 1

    while current_index < len(self.chain):
      block = self.chain[current_index]
      transactions = block['transactions']

      for t in transactions:
        t = json.loads(t)
        if t['t_type'] == 'basic' or t['t_type'] == 'coinbase_transaction':
          outputs_t = t['outputs']
          for ot in outputs_t:
            if ot == transaction_output:
              return True

    return False

  def _get_double_sha256(self,message):
    return hashlib.sha256(hashlib.sha256(message).digest()).digest()

  def get_hash(self,block):
    """
    """
    print('BlockchainManager: get_hash was called!')
    block_string = json.dumps(block, sort_keys=True)
    return binascii.hexlify(self._get_double_sha256((block_string).encode('utf-8'))).decode('ascii')

