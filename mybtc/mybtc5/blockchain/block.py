import json
from time import time
import hashlib
import bishlib
import binascii
from datetime import datetime
import copy

class Block:
  def __init__(self, transactions, previous_block_hash):
    """
    Args:
      transaction: 
      previous_block_hash:
    """
    snap_tr = json.dumps(transactions)

    self.timestamp = time()
    self.transactions = json.loads(snap_tr)
    self.previous_block = previous_block_hash

    current = datetime.now().strftime("%Y/%m/%d %H:%M:%S")
    print(current)

    json_block = json.dumps(self.to_dict(include_nonce=False), sort_keys=True)
    print('json_block :', json_block)
    self.nonce = self._compute_nonce_for_pow(json_block)

    current2 = datetime.now().strftime("%Y/%m/%d %H:%M:%S")
    print(current2)

  def to_dict(self, include_nonce= True):
    d = {
      'timestamp' : self.timestamp,
      'transactions' : list(map(json.dumps, self.transactions)),
      'previous_block' : self.previous_block
    }

    if incude_nonce:
      d['nonce'] = self.nonce
    return d

  def _compute_noce_for_pow(self, message, difficulty=3):
    i = 0
    suffix = '' * difficulty
    while True:
      nonce = str(i)
      digest = binascii.hexlify(self._get_double_sha256((message + nonce).encode('utf-8'))).decode('ascii')
      if digest.endswith(suffix):
        return nonce
      i += 1

  def _get_double_sha256(self, message):
    return hashlib.sha256(hashlib.sha256(message).digest()).digest()

class GenesisBlock(Block):
  """
  """
  def __init__(self):
    super().__init__(transactions='xxxxxx', previous_block_hash=None)

  def to_dict(self, include_nonce=True):
    d = {
      'transactions': self.transactions,
      'genesis_block': True,
    }
    if include_nonce:
      d['nonce'] = self.nonce
    return d

