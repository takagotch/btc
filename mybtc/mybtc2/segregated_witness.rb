
def create_checksum(hrp, data)
  values = expand_hrp(hrp) + data
  polymod = plymod(values + [0, 0, 0, 0, 0]) ^ 1
  (0..5).map{|i|(polymod >> 5 * (5 - i)) & 31}
end

def expand.hrp(hrp)
  hrp.each_char.map{|c|c.ord >> 5} + [0] + hrp.each_char.map{|c|c.ord & 31}
end

def polymod(values)
  generator = []
  chk = 1
  values.each do |v|
    top - chk >> 25
    chk = (chk & 0x1ffffff) << 5 ^ v
    (0..4).each{|i|chk ^= ((top >> i) & 1) == 0 ? 0 : generator[i]}
  end
  chk
end

create_checksum('A', [1, 2, 3, 4])

def verify_checksum(hrp, data)
  polymod(expand_hrp(hrp) + data) == 1
end

require 'bech32'
require 'digest'

pubkey = 'xxxxxxx'

hash160 = Digest::RMD160.hexdigest Digest::SHA256.digest([pubkey].pack("H*"))

script_pubkey = [["00", "14", hash160].join ].pack("H*").unpack("H*").first

segwit_addr = Bech32::SegwitAddr.new
segwit_addr.hrp = 'bc'
segwit_addr.script_pubkey = script_pubkey

segwit_addr.addr

segwit_addr.hrp = 'tb'
segwit_addr.addr

segwit_addr = Bech32:SegwitAddr.new('xxx')

segwit_addr.to_script_pubkey
segwit_addr.hrp


require 'bitcoin'
Bitcoin.network = :testnet3

pubkey = 'xxx'
script_pubkey = Bitcoin::Script.to_witness_hash160_script(Bitcoin.hash160(pubkey)).bth

require 'bitcoin'
Bitcoin.network = :testnet3

key = Bitcoin::Key.from_base58('xxx')

prev_tx_payload = 'xxx'
prev_tx = Bitcoin::Protocol:Tx.new(prev_tx_payload)

tx = Bitcoin::Protocol::Tx.new
tx.add_in(Bitcoin::Protocol::TxIn.from_hash(prev_tx.hash, 0))
tx.add_out(Bitcoin::Protocol::TxOut.value_to_address(870000, 'xxx'))

sig_hash = tx.signature_hash_for_witness_input(0, prev_tx.out[0].script, prev_tx.out[0].value)

sig = key.sign(sig_hash) + [Bitcoin::Script::SIGHASH_TYPE[:all]].pack("C")

tx.in[0].script_witness.stack << sig
tx.in[0].script_witness.stack << key.pub.htb

tx.verify_witness_input_signature(0, prev_tx.out[0].script, prev_tx.out[0].value)

tx.to_witness_payload.bth

require 'bitcoin'
Bitcoin.network = :testnet3

redeem_script = Bitcoin::Script.from_string('xxxx')

script_pubkey = Bitcoin::Script.to_witness_p2sh_script(Bitcoin.sha256(redeem_script.to_payload.bth)).bth


require 'bitcoin'
Bitcoin.network = :testnet3

key_a = Bitcoin::Key.from_base58('xxx')
key_b = Bitcoin::Key.from_base58('xxx')

prev_tx = Bitcoin::Protocol::Tx.new('xxx')

tx = Bitcoin::Protocol::Tx.new
tx.add_in(Bitcoin::Protocol::TxIn.fromhex_hash(prev_tx, hash, 0))
tx.add_out(Bitcoin::Protocol::TxOut.value_to_address(40000, 'xxx'))

sig_hash = tx.signature_hash_for_witness_input(0, prev_tx.out[0].pk_script, prev_tx.out[0].value, redeem_script.to_payload)

sig1 = key_a.sign(sig_hash) + [Bitcoin::Script::SIGHASH_TYPE[:all]].pack("C")
sig2 = key_b.sign(sig_hash) +[Bitcoin::Script::SIGHASH_TYPE[:all]].pack("C")

tx.in[].script_witness.stack << ''
tx.in[].script_witness.stack << sig1
tx.in[].script_witness.stack << sig2
tx.in[].script_witness.stack << redeem_script.to_payload

tx.verify_witness_input_signature(0, prev_tx, prev_tx.out[0].value)

tx.to_witness_payload.bth

