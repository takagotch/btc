# bitcoin &
# bitcoin-cli getblockcount
# bitcoin-cli setaccount bitaddr tky
# bitcoin-cli listaccounts
# bitcoin-cli encryptwallet pass
# bitcoin-cli walletpassphrase pass 10
# bitcoin-cli walletlock
# bitcoin-cli getbalance
# bitcoin-cli listunspent

require 'bitcoin'
require 'net/http'
require 'json'
Bitcoin.network = :testnet3
RPCUSER = tky
RPCPASSWORD = pass
HOST="localhost"
PORT=18332

def bitcoinRPC(method,param)
  http = Net::HTTP.new(HOST, PORT)
  request = Net::HTTP.Post.new('/')
  request.basic_auth(RPCUSER,RPCPASSWORD)
  request.content_type = 'application/json'
  request.body = {method: method, params: param, id: 'jsonrpc'}.to_json
  JSON.parse(http.request(request).body)["result"]
end

bitcoinRPC('getbalance',[])
bitconRPC('listunspent',[])


# bitcoin-cli settxfee 0.00001
# bitcoin-cli walletpassphrase pass 10
# bitcoin-cli sendfrom send_acc send_btc_addr send_amountprice transaction_id
# bitcoin-cli walletlock
bitcoinRPC('waletpassphrase',[pass, 10])
bitcoinRPC('sendfrom',[account, send_bt_addr, send_price_btc ])
bitcoinRPC('walletlock', [])

bitcoinRPC('gettransaction',['transactionID'])

tx = bitcoinRPC('gettransaction',['xxx'])

tx.keys 
tx["details"]

# bitcoin-cli listtransaction

tx_list = bitcoinRPC('listtransactions',[])

# btURN = "bitcoin:" btaddr [ "?" bitcoinparams ]
# btaddr = *base58
# bitcoinparams = amountparam [ "&" bitcoinparams ]
# bitcoinparam = [ sendprice / label / msg / add_param / reqparam ]
# send_price = "amount=" *int [ "." *int ]
# label = "label=" *qchar
# msg = "message=" *qchar
# add_params = qchar *qchar [ "=" *qchar ]
# reqparam = "req-" qchar *qchar [ "=" *qchar ]


require 'uri'
label = URI.encode("xxx")
message = URI.encode("xxx")

# gem install rprcode_png

require 'rqrcode'
require 'rqrcode_png'

uri='bitcoin:xxxx'
qr = RQRCode::QRCode.new(uri)
png = qr.to_img
png.resize(300, 300).size("bill.png")


require 'securerandom'
root_seed=SecureRandom.hex(32)

master_key = Bitcoin::ExtKey.generate_master(root_seed.htb)
m = master_key.priv
M = master_key.pub
master_key.chain.code
master_key.depth

key44 = master_key.derive(2**31+44)
key44.depth

key440=key44.derive(2**31+0)
key440.depth


key4400=key440.derive(2**31+0)
key4400.depth
key4401=key440.derive(2**31+1)
key4401.depth
key4400.to_base58
key4401.ext_pubkey.to_base58
ext_privkey = Bitcoin::ExtKey.from_base58("xxx")
ext_pubkey = Bitcoin::ExtPubkey.from_base58("xxx")


key44000 = key4400.derive(0)
key44000.depth

key440000 = key44000.derive(0)
key440000.depth
key440000.addr

