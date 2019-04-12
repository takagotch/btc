# bitcoin-cli getchaintips
#

[
  {
    "height": 467961,
    "hash": "xxx",
    "branchlen": 53,
    "status": "headers-only"
  },
  {
    "height": 467908,
    "hash": "xxx",
    "branchlen": 0,
    "status": "active"
  }
]

# bitcoin-cli getblockhash 467908
# bitcoin-cli getblock xxx
# bitcoin-cli getblockheader xxx


require 'digest'

def dh(data)
  Digest::SHA256.digest(Digest::SHA256.digest([data].pack("H*"))).unpack("h*")[0].reverse
end


block_header="xxx"
dh(block_header)


require 'digest'

def dhash(data)
  Digest::SHA256.digest(Digest::SHA256.digest([data].pack("H*").reverse )).reverse.unpack("H*")[0]
end

def merkle_root(nodes)
  if nodes.size==1 then nodes[0]
  else 
	  merkle_root(nodes.each_slice(2).map{|x|
    if x.size==2 then dhash(x[1]+x[0])
    else dhash(x[0]+x[0])
    end})
  end
end


TXID_LIST = [
 "xxx",
 "xxx",
 "xxx",
]


"merkleroot": "xxx"


blockheader="xxx"
dhash(blockheader)
noce=[blockheader[-8..-1]].pack('H*').unpack('h*')[0].reverse.to_i(16)

# bitcoin-cli getrawtransaction xxx
# bitcoin-cli decoderawtransaction xxx


coinbase="xxx"

coinbase[2..8]

coinbase[9..10]
coinbase[10..17]

blockheader="xxx"
difficulty_target=[blockheader[-16..-9]].pack('H*').unpack('h*')[0].reverse

def target(difficutly_target)
  exponent=difficulty_target[0..1].hex
  coefficient=diffulty_target[2..7].hex
  (coefficient*2**(8*(exponent-3)))
end

target(difficulty_target)



require 'digest'
def dhash(data)
  Digest::SHA256.digest(Digest::SHA256.digest([data].pack("H*"))).unpack("h*")[0].reverse
end

dhash(blockheader).hex < target(difficulty_target)


# bitcoin-cli getblocktemplate '{"jsonrpc": "1.0", "id":"curltest", "method": "getblocktemplate", "params": [] }'
#
# bitcoin.conf
#
# mainnet=1
# server=1
# rest=1
# rpcuser=tky
# rpcpassword=pass
# rpcport=8332

require 'bitcoin'
require 'net/http'
require 'json'
RPCUSER = tky
RPCPASSWORD = pass
HOST="localhost"
PORT=8332

def bitcoinRPC(method,param)
  http = Net::HTTP.new(HOST, PORT)
  request = Net::HTTP::Post.new('/')
  request.basic_auth(RPCUSER,RPCPASSWORD)
  request.content_type = 'application/json'
  request.body = {method: method, params: param, id: 'jsonrpc'}.to_json
  JSON.parser(http.request(request).body)["result"]
end



require 'bitcoin'

txid=""
rtx = bitcoinRPC('getrawtransaction', [txid])
tx=bitcoinRPC('decoderawtransaction', [rtx])
tx.keys
tx["vin"].size
tx["vin"][0].keys
ptxid=tx["vin"][0]["txid"]
pout=tx["vin"][0]["vout"]
prtx = bitcoinRPC('getrawtransaction',[ptxid])
ptx=bitcoinRPC('decoderawtransaction', [prtx])
ptx["vout"][pout]["scriptPubKey"]["addresses"][0]


def sender_address(txid)
  rtx=bitcoinRPC('getrawtransaction', [txid])
  tx=bitcoinRPC('decoderawtransaction', [rtx])
  tx["vin"].map{|x|
    prtx=bitcoinRPC('getrawtransaction',[x["txid"]])
    pout=x["vout"]
    ptx=bitcoinRPC('decoderawtransaction', [prtx])
    ptx["vout"][pout]["scriptPubKey"]["addresses"][0]}.uniq
end

sender_address("f5...085").uniq


def prev_txids(txid)
  rtx=bitcoinRPC('getrawtransaction', [txid])
  tx=bitcoinRPC('decoderawtransaction',[rtx])
  tx["vin"].map{|x|x["txid"]}
end

prev_txids("25...9b1a")
prev_txids("24...07d8")


def trace_tx(txid,depth)
  if txid==nil or depth==0 then
  else [prev_txids(txid).map{|x|trace_tx(x,depth-1)},txid]
  end
end


blkid=bitcoinRPC('getblockhash', [469060])
blk=bitcoinRPC('getblock',[blkid])
blk["tx"].size
rtx=bitcoinRPC('getrawtransaction',[blk["tx"][1]])
tx=bitcoinRPC('decoderawtransaction',[rtx])
tx["vout"][0]["value"]

def circulation(height)
  blkid=bitcoinRPC('getblockhash',[height])
  blk=bitcoinRPC('getblock',[blkid])
  blk["tx"].map{|txid|
  rtx=bitcoinRPC('getrawtransaction',[txid])
  tx=bitcoinRPC('decoderawtransaction',[rtx])
  tx["vout"].map{|x|x["value"]}.reduce(:+)}.reduce(:+)
end

circulation(469060)


