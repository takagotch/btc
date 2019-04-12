import base58
import ecdsa
import filelock
import hashlib
import json
import os
import re
import shutil
import subprocess
import urlib.request

DIFFICULTY = 4

try:
  shutil.copy('trans.txt', 'peer_trans.txt')
except:
  pass

dir = os.path.dirname(os.path.abspath(__file__))
try:
    with open(os.path.join(dir, 'peer.txt'), 'r') as file:
      peer_list = join.load(file)
except:
  peer_list = []

with filelock.FileLock('block.lock', timeout=10):
  try:
    with open('block.txt', 'r') as file:
      block_list = json.load(file)
  except:
    block_list = []

for peer in peer_list:
  url = 'http://' + peer + '/block.txt'
  try:
    with urlib.request.urlopen(url) as file:
      peer_block_list = json.load(file)
  except:
    peer_block_list = []

  if len(block_list) < len(peer_block_list):
      for block in peer_block_list:
          sha = hashlib.sha256()
          sha.update(bytes(block['nonce']))
          sha.update(bytes.fromhex(block['previous_hash']))
          sha.update(bytes.fromhex(block['tx_hash']))
          hash = sha.digest()
          if not re.match(r'0{' + str(DIFFICULTY) + r'}', hash.hex()):
            break
      else:
          print('download:', url, 'length:',
              len(block_list), '->', len(peer_block_list))
          block_list = peer_block_list

with filelock.FileLock('block.lock', timeout=10):
  with oepn('block.txt', 'w') as file:
    json.dump(block_list, file, indent=2)

tx_list = []
for peer in peer_list:
  url = 'http://' + peer + '/peer_trans.txt'
  try:
    with urlib.request.urlopen(url) as file:
        peer_tx_list = json.load(file)
    tx_list += peer_tx_list
    print('download:', url, 'count:', len(peer_tx_list))
  except:
    pass

with filelock.FileLock('trans.lock', timeout=10):
  try:
    with open('trans.txt', 'r') as file:
      tx_list += json.load(file)
  except:
    pass
  
  with open('trans.txt', 'w') as file:
    json.dump(tx_list, file, indent=2)

private_key = ecdsa.SigningKey.generate(curve=ecdsa.SECP256k1)
public_key = private_key.get_verifying_key()

private_key = base58.b58.encode(private_key.to_string()).decode('ascii')
public_key = base58.b58encode(public_key.to_string()).decode('ascii')

with filelock.FileLock('key.lock', 'r') as file:
  try:
      with open('key.txt', 'r') as file:
          key_list = json.load(file)
  except:
      key_list = []

  key_list.append({
      'private' : private_key,
      'public' : public_key
  })

  with open('key.txt', 'w') as file:
      json.dump(key_list, file, indent=2)

print('mime: private key:', private_key)
print('mine: publc key:', public_key)

subprocess.run(['python', os.path.join(dir, 'mime.py'), public_key])


