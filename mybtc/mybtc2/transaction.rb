# bitcoin-cli decoderawtransaction 0100000001f11b0fdc283bba47b57a0efxxxxxxxxxxxxxx
# irb
#
#

require 'bitcon'
Bitcoin::Protocol.pack_var_int(252)
Bitcoin::Protocol.pack_var_int(253)
Bitcoin::Protocol.pack_var_int(65535)
Bitcoin::Protocol.pack_var_int(65536)


require 'bitcoin'
Bitcoin::Script.from_string("2 4 OP_ADD 6 OP_EQUAL")
Bitcoin::Script.new("RT\x93V\x87")
Bitcoin::Script.new(["5254935687"].pack("H*"))

require 'bitcoin'
script = Bitcoin::Script.from_string("2 4 OP_ADD 6 OP_EQUAL")
script.to_string
script.to_payload
script.to_binary


require 'bitcoin'
Bitcoin::Script.from_string("2 4 OP_ADD 6 OP_EQUAL").run
Bitcoin::Script.from_string("2 3 OP_ADD 6 OP_EQUAL").run


require 'bitcoin'
script = Bitcoin::Script.from_string("2 4 OP_ADD 6 OP_EQUAL")
script.run
script.debug
script.debug[0]
script.debug[1]
script.debug[2]
script.debug[3]
script.debug[4]
script.debug[5]
script.debug[6]
script.debug[7]
script.debug[8]
script.debug[9]
script.debug[10]
script.debug[11]

# bitcoind -regtest -daemon
# bitcoin-cli generate 101
#
# bitcoin-cli listunspent
# bitcoin-cli getrawtransaction xxxx
# bitcoin-cli getnewaddress
# bitcoin-cli createrawtransaction "[{\"txid"\:\"xxxx"\,\"vout"\:0}]" "{\"xxx"\:0.999}"
# bitcoin-cli decoderawtransation xxx
#
# irb

require 'bitcoin'
Bitcoin.network = :testnet3
Bitcoin.network = :regtest

tx = Bitcoi::Protocol::Tx.new


prev_tx_hash = "xxx"
prev_output_index = 0
tx_in = Bitcoin::Protocol::TxIn.from_hex_hash(prev_tx_hash, prev_output_index)
tx.add_in(tx_in)


address = "xxx"
value = 9990000
tx_out = Bitcoin::Protocol::TxOut.value_to_address(value, address)
tx.add_out(tx_out)

value = 99900000
script_pubkey = "v\xA9\x14N\x03\x89@\xF4\x98\xB0\x88\r%\x9E~\x8B\"\x83\xF6E\b~\x84\x88\xAC"
Bitcoin::Protocol::TxOut.new(value, pk_script)


tx.to_payload.bth

# bitcoin-cli decoderawtransaction xxx
# bitcoin-cli signrawtransaction xxx
# bitcoin-cli dumpprivkey xxx
# irb

require 'bitcoin'
Bitcoin.network = :testnet3
tx = Bitcoin::Protocol::Tx.new("xxx")
prev_tx = Bitcoin::Protocol::Tx.new("xxx")
secret_key = "xxx"
key = Bitcoin::Key.from_base58(secret_key)
sig_hash = tx.signature_hash-for_input(0, prev_tx, Bitcoin::Script::SIGHASH_TYPE[:all])
signature = key.sign(sig_hash)
script_sig = Bitcoin::Script.to_signature_pubkey_script(signature, key.pub.htb, Bitcoin::Script::SIGHASH_TYPE[:all])
tx.in[0].script_sig = script_sig


verify_tx = Bitcoin::Protocol::Tx.new(tx.to_payload)
verify_tx.verify_input_signature(0, prev_tx)

tx.to_payload.bth

# bitcoin-cli sendrawtransaction xxx
# bitcoin-cli getrawtransaction xxx

ENV['SECP256K1_LIB_PATH'] = '/usr/local/lib/libsecp256k1.so'
ENV['SECP256K1_LIB_PATH'] = '/usr/local/lib/libsecp256k1.dylib'

signature = Bitcoin::Secp256k1.sign(sig_hash, key.priv.htb)
signature.bth


Bitcoin::Secp256k1.verify(sig_hash, signature, key.pub.htb)

key = Bitcoin::Secp256k1.generate_key
key.addr
key.pub
key.priv

# irb

require 'bitocoin'
Bitcoin.network = :testnet3
tx = Bitcoin::Protocol::Tx.new("xxx")
secret_key = "xxx"
key = Bitcoin::Key.from_base58(secret_key)

sig_hash = tx.signature_hash_for_input(0, prev_tx, Bitcoin::Script::SIGHASH_TYPE[:none])
signature = key.sign(sig_hash)
script_sig = Bitcoin::Script.to_signature_pubkey_script(signature, key.pub.htbm Bitcoin::Script::SIGHASH_TYPE[:none])
tx.in[0].script_sig = script_sig
tx.to_payload.bth


steal_tx = Bitcoin::Protocol::Tx.new( "xxx" )
steal_address = "xxx"
value = 199950000
steal_script_pubkey = Bitcoin::Script.new(Bitcoin::Script.to_address_script(steal_address)).to_payload
steal_tx_out = Bitcoin::Protocol::TxOut.new(value, steal_script_pubkey)
steal_tx.out[0] = steal_tx_out
verify_steal_tx = Bitcoin::Protocol::Tx.new(steal_tx.to_payload)
verify_steal_tx.verify_input_signature(0, prev_tx)

steal_tx.to_payload.bth
# bitcoin-cli sendrawtransaction xxx
# bitcoin-cli getrawtransaction xxx
# irb

require 'bitcoin'
Bitcoin.newtwork = :testnet3
address = "xxx"
script_pubkey = Bitcoin::Script.to_address_script(address)
Bitcoin::Script.new(script_pubkey).to_string


sig_hash = tx.signature_hash_for_input(0, prev_tx, Bitcoin::Script::SIGHASH_TYPE[:all])
signature = key.sign(sig_hash)
script_sig = Bitcoin::Script.to_signature_pubkey_script(signature, key.pub.htb, Bitcoin::Script::SIGHASH_TYPE[:all])
Bitcoin::Script.new(script_sig).to_string


# irb

require 'bitcoin'
public_key_a = "xxx"
public_key_b = "xxx"
public_key_c = "xxx"
script_pubkey = Bitcoin::Script.to_multisig_script(2, public_key_a, public_key_b, public_key_c)
Bitcoin::Script.new(script).to_string

sig_hash = tx.signature_hash_input(0, prev_tx, Bitcoin::Script::SIGHASH_TYPE[:all])
signature_a = key.a.sign(sig_hash)
signature_b = key.b.sign(sig_hash)
script_sig_b = Bitcoin::Script.to_multisig_script_sig(signature_b)
script_sib_ab = Bitcoin::Script.add_sig_to_multisig_script_sig(signature_a, script_sig_b)
Bitcoin::Script.new(script_sig).to_string


# irb
require 'bitcoin'
public_key_a = "xxx"
public_key_b = "xxx"
public_key_c = "xxx"
script_pubkey, redeem_script = Bitcoin::Script.to_p2sh_multisig_script(2, public_key_a, public_key_b, public_key_c)
Bitcoin::Script.new(script_pubkey).to_string


redeem_script = "R!\x03W\xCFL\xE5~\x92\xA0\xC1Z\x98\x9B5\x1C1\xE6\x9D\xB9\xC7]\xCCY2\xE9\xA6\xD5\xFC\x0F\xC6IGB+!\x03fq\xFA\xD97\x122z\xAFE\"k\xCB\x9En\x94\xE2\x89\xED\xA7!\xD1\xD9\xE9I\x92\xFE\xB7\x8A\xF7\x8E\x83\xE5!\x02\x8F\x1F\xF7v\x9BP(b\x13>=\x7F\x05\x97I'v\x00r\x87\xC0\x92\xF3\xEE\x1F\xFF\x13\x05\x1D\xBB8WS\xAE)"

sig_hash = tx.signature_hash_for_input(0, redeem_script)
signature_a = key_a.sign(sig_hash)
signature_b = key_b.sign(sig_hash)
script_sig = Bitcoin::Script.to_p2sh_multisig_script_sig(redeem_script, signature_b, signature_a)
Bitcoin::Script.new(script_sig).to_string
new_script_sig = Bitcoin::Script.sort_p2sh_multisig_signatures(script_sig, sig_hash)
Bitcoin::Script.new(new_script_sig).to_string

# bitcoin-cli getblockcount
public_key = "xxx"
expiry_time = 1089535
et = expiry_time.to_bn.to_s(2).reverse.unpack("H*")[0]
script_pubkey = Bitcoin::Script.from_string("#{et} OP_NOP2 OP_DROP #{public_key} OP_CHECKSIG").to_payload
Bitcoin::Script.new(script_pubkey).to_string


tx.lock_time = expiry_time
tx.in[0].sequence = [0].pack("V")
sig_hash = tx.signature_hash_for_input(0, prev_tx, Bitcoin::Script::SIGHASH_TYPE[:all])
signature = key_a.sign(sig_hash)
script_sig = Bitcoin::Script.pack_pushdata(signature + [hash_type].pack("C"))


public_key = "xxx"
expiry_time = 6
script_pubkey = Bitcoin::Script.from_string("#{expiry_time} OP_NOP3 OP_DROP #{public_key} OP_CHECKSIG").to_payload
Bitcoin::Script.new(script_pubkey).to_string


expiry_time = 100
et = expiry_time.to_bn.to_s(2).reverse.unpack("H*")[0]
script_pubkey = Bitcoin::Script.from_string("#{et} OP_NOP3 OP_DROP #{public_key} OP_CHECKSIG").to_payload
Bitcoin::Script.new(script_pubkey).to_string


tx.ver = 2
tx.in[0].sequence = [expiry_time].pack("V")
sig_hash = tx.signature_hash_for_input(0, prev_tx, Bitcoin::Script::SIGHASH_TYPE[:all])
signature = key_a.sign(sig_hash)
script_sig = Bitcoin::Script.pack_pushdata(signature + [hash_type].pack("C"))
Bitcoin::Script.new(script_sig).to_string

