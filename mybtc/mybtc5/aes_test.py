import binascii
import base64

from utils.aes_util import AESUtil
from utils.key_manager import KeyManager

def main():
  my_km = KeyManager()
  target_txt = ''
  print('target text:', target_txt)
  
  aes_util = AESUtil()
  cipher_txt = aes_util.encrypt(target_txt)
  print('cipher_tx : ', base64.b64encode(cipher_txt))

  key = aes_util.get_aes_key()
  print('aes_key : ', binascii.hexlify(key).decode('ascii'))

  encrypted_key = my_km.encrypt_with_my_pubkey(key)
  print('encrypted_key : ', binascii.hexlify(encrypted_key[0]).decode('accii'))

  key_to_be_send = binascii.hexlify(base64.b64encode(encrypted_key[0])).decode('ascii')
  print('to_be_send', key_to_be_send)

  un_hex = base64.b64decode(binascii.unhexlify(key_to_be_send))
  print('un_hex', un_hex)

  decrypted_key2 = my_km.decrypt_with_private_key(un_hex)
  print('descrypted_key : ', binascii.hexlify(decrypted_key2).decode('ascii'))

  dec2 = aes_util.decrypt_with_key(cipher_txt, key)
  print('decoded text : ', dec2.decode('utf-8'))

if __name__ == '__main__':
  
    main()

