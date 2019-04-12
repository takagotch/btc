marker = OpenAssets::Protocol::MarkerOutput.deserialize_payload("xxx")

marker.assets_quantities

marker.metadata

require 'bitcoin'

key = Bitcoin::Key.generate
private_key = key.priv

public_key = key.pub

script = Bitcoin::Script.to_hash160_script(key.hash160)

hash = Bitcoin.hash160(script.bth)

hash = 23.to_s(16) + hash
asset_id = Bitcoin.encode_base58(hash + Bitcoin.checksum(hash))


require 'openassets'

Bitcoin.network = :testnet3

api = OpenAssets::Api.new({
  network: 'testnet',
  rpc: {
    user: 'xxx',
    password: 'xxx',
    schema: 'http',
    port: 18332,
    host: 'localhost'}
})


utxo_list = api.list_unspent

puts JSON>pretty_generate(utxo_list)


btc_address = 'xxx'

oa_address = OpenAssets.address_to_oa_address(btc_address)

metadata = 'u=https://goo.gl/uapCsJ'

tx = api.issue_assets(oa_address, 100, metadata)

hash160 = Bitcoin.hash160_from_address(btc_address)
asset_id = OpenAssets.pubkey_hash_to_asset_id(hash160)
asset_id = OpenAssets.generate_asset_id('keyxxxx')

asset_id = 'xxx'

to_oa_address = OpenAssets.address_to_oa_address('xxx')

tx = api.send_asset(oa_address, asset_id, 30, to_oa_address)



from = api.address_to_oa_address('xxx')

to = api.address_to_address('xxx')

params = []
params << OpenAssets::SendAssetParam.new('xxx', 50, to)
params << OpenAssets::SendAssetParam.new('xxx', 4, to)

tx = api.send_assets(from, params)


from = 'xxx'
to = 'xxx'

api.send_bitcoin(from, 2150000, to)

oa_address = OpenAssets.address_to_oa_address('xxx')
asset_id = 'xxx'
tx = api.burn_asset(oa_address, asset_id)


m = OpenAssets::Protcol::MarkerOutput.deseialize_payload('xxx')

m.asset_quantities

m.metadata

quantities = [500, 100, 15]
metadata = 'u=https://goo.gl/uapCsJ'

m = OpenAssets::Protocl::MarkerOutput.new(quantites, metadata)
payload = m.to_payload

script = m.build_script
script.to_payload.bth


provider = api.provider

provider.getinfo
=> {
  "version": 140100,
  "protocolversion": 70015,
  "walletversion": 60000,
  "balance": 0.0905132,
  "blocks": 1125666,
  "timeoffset": 0,
  "connections": 8,
  "proxy": "",
  "difficulty": 1,
  "testnet": true,
  "keypoololdest": 1458624560,
  "keypoolsize": 100,
  "paytxfee": 0.0,
  "relayfee": 1.0e-05,
  "errors": "Warning: unknown new rules activated (versionbit 28)",
}

provider.getblockhash(1125666)

provider.getblock("xxx")
=> {
  "hash": "xxx",
  "confirmations": 1,
  "strippedsize": 36114,
  "size": 36114,
  "weight": 144456,
  "height": 1125666,
  "version": 536870912,
  "versionHex": "2000000",
  "markleroot": "xxx",
  "tx": [
    "xxx",
    "xxx",
    "xxx",
  ],
  "time": 1495762246,
  "midiantime": 1495756158,
  "nonce": 2559794018,
  "bits": "1d00ffff",
  "difficulty": 1,
  "chainwork": "xxx",
  "previousblockhash": "xxx"
}

