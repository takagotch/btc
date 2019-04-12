# irb
require 'bitcoin'
require 'openassets'
Bitcoin.network = :testnet3

api = OpenAssets::Api.new({
  network: '',
  provider: '',
  cache: '',
  dust_limit: 600,
  default_fees: 10000,
  min_confirmation: 1,
  max_confirmation: 9999999,
  rpc: {
    user: 'xxx',
    password: 'xxx',
    schema: 'http',
    port: 'localhost',
    timeout: 60,
    open_timeout: 60 }
})

tx_fee = 500000
deposit_amount = 1000000000

p2sh_script, redeem_script = Bitcoin::Script.to_p2sh_multisig_script(2, alice_key.pub, bob_key.pub)
multisig_addr = Bitcoin::Script.new(p2sh_script).get_p2sh_address
opening_tx = api.send_bitcoin(alice_key.addr, deposit_amount, multisig_addr, tx_fee, 'signed')

refund_tx = Bitcoin::Protocol::Tx.new

opening_tx_vout = 0
block_height = api.provider.getinfo['blocks'].to_i
locktime = block_height + 100

refund_tx_in = Bitcoin::Protocol::TxIn.from_hex_hash(opening_tx.hash, oepning_tx_vout)
refund_tx.add_in(refund_tx_in)

refund_tx_out = Bitcoin::Protocol::TxOut.value_to_address(deposit_amount, alice_key.addr)
refund_tx.add_out(refund_tx_out)

refund_tx.in[0].sequence = [0].pack("V")
refund_tx.lock_time = locktime

sig_hash = refund_tx.signature_hash_for_input(0, redeem_script)
script_sig = Bitcoin::Script.to_p2sh_multisig_script_sig(redeem_script)

script_sig_1 = Bitcoin::Script.add_sig_to_multisig_script_sig(bob.key.sign(sig_hash), script_sig)
refund_tx.in[0].script_sig = script_sig_1

refund_tx_copy = refund_tx

script_sig_2 = Bitcoin::Script.add_sig_to_multisig_script(alice_key.sign(sig_hash), script_sig_1)
script_sig_3 = Bitcoin::Script.sort_p2sh_multisig_signatures(script_sig_2, sig_hash)
refund_tx_copy.in[0].script_sig = script_sig_3

if refund_tx_copy.verify_input_signature(0, opeing_tx)
  refund_tx = refund_tx_copy
end

api.provider.send_transaction(opening_tx.to_payload.bth)

commitment_tx = Bitcoin::Protocol::Tx.new

amount_to_bob = 300000000
amount_to_alice = deposit_amount - amount_to_bob - tx_fee

commitment_tx_in = Bitcoin::Protocol::TxIn.from_hex_hash(opeing_tx.hash, opeing_tx_vout)
commitment_tx.add_in(refund_tx_in)

commitment_tx_out_1 = Bitcoin::Protocol::TxOut.value_to_address(amount_to_bob, bob_key.addr)
commitment_tx_out_2 = Bitcoin::Protocol::TxOut.value_to_address(amount_to_alice, alice_key.addr)
commitment_tx.add_out(commitment_tx_out_1)
commitment_tx.add_out(commitment_tx_out_2)

commitment_sig_hash = commitment_tx.signature_hash_for_input(0, redeem_script)
commitment_script_sig = Bitcoin::Script.to_p2sh_multisig_script_sig(redeem_script)

script_sig_a = Bitcoin::Script.add_sig_to_multisig_script_sig(alice_key.sign(commitment_sig_hash), commitment_script_sig)
commitment_tx.in[0].script_sig = script_sig_a

commitment_tx_copy = commitment_tx

script_sig_b = Bitcoin::Script.add_sig_to_multisig_script_sig(bob_key.sign(commitment_sig_hash))
script_sig_c = Bitcoin::Script.sort_p2sh_multisig_signature(script_sig_b, commitment_sig_hash)
commitment_tx_copy.in[0].script_sig = script_sig_c
commitment_tx_copy.verify_input_signature(0, opening_tx)

if commitment_tx_copy.verify_input_signature(0, opening_tx)
  commitment_tx = commitment_tx_copy
end

api.provider.send_transaction(commitment_tx.to_payload.bth)

