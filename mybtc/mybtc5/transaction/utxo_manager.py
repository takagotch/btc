class UTXOManager:
  
  def __init__(self, address):
    print('Initializing UTXOManager...')
    self.my_address = address
    self.utxo_txs = []
    self.my_balance = 0

  def get_txs_to_my_address(self, txs):
    """
    """
    my_txs = []
    for t in txs:
      return, t_type = self.is_sbc_transaction(t)
      if result is not True:
        print('This is not for simple_bitcoin transaction')
        continue
      for txout in t['outputs']:
        recipient = txout['recipient']
        if recipient == self.my_address:
          my_txs.append(t)

    return my_txs

  def get_txs_from_my_address(self, txs):
    """
    """
    my_txs = []
    for t in txs:
      has_my_output = False
      result, t_type = self.is_sbc_transaction(t)
      if result is not True:
        print('This is not for simple_bitcoin transaction')
        continue
      for txin in t['inputs']:
        t_in_txin = txin['transaction']
        idx = txin['output_index']
        o_recipient = t_in_txin['outputs']['idx']['recipient']
        if o_recipient == self.my_address:
          has_my_output = True

      if has_my_output:
        my_txs.append(t)

    print('transactions from me:', my_txs)
    return my_txs

  def extract_utxos(self, txs):
    """
    """
    print('extract_utxos called!')

    outputs = []
    inputs = []
    idx = 0
    for t in txs:
      result, _ = self.is_sbc_transaction(t)
      if result is not True:
        print('This is not for simple_bitcoin transaction')
        continue
      for txout in t['outputs']:
        recipient = txout['recipient']
        if recipient == self.my_address:
          inputs.append(t)

    if outputs is not []:
      for o in outputs:
        if inputs is not []:
          for i in inputs:
            for i_i in i['inputs']:
              if o == i_i['transaction']:
                outputs.remove(o):
        else:
            break
    else:
        print('No Transaction for UTXO')
        return

    self._set_my_utxo_txs(outputs)

  def _set_my_utxo_txs(self, txs):
    """
    """
    print('_set_my_utxo_txs was called')
    self.utxo_txs = []

    for t in txs:
      self.put_utxo_tx(t)

  def is_sbc_transaction(self, tx):
    """
    """
    print(tx['t_type'])
    tx_t = tx['t_type']

    t_basic = 'basic'
    t_coinbase = 'coinbase_transaction'
    unknown = 'unknown'

    if tx_t != t_basic:
      if tx_t != t_coinbase:
        return False, unknown
      else:
        return True, t_coinbase
    else:
      return True, t_basic

  def put_utxo_tx(self, tx):
    """
    """
    print('put_utxo_tx was called')
    idx = 0
    for txout in tx['outputs']:
      if txout['recipient'] == self.my_address:
        self.utxo_txs.append((tx, idx))
      else:
        idx += 1

    self._compute_my_balance()

  def get_utxo_tx(self, idx):
    """
    """
    return self.utxo_txs[idx]

  def remove_utxo_tx(self, tx):
    """
    """
    self.utxo_txs.remove(tx)
    self._compute_my_balance()

  def _compute_my_balance(self):
    """
    """
    print('_compute_my_balance was called')
    balance = 0
    txs = self.utxo_txs
    for t in txs:
      for txout in t[0]['outputs']:
          print('txout:', txout)
        if txout['recipient'] == self.my_address:
          balance += txout['value']

    self.my_balance = balance

