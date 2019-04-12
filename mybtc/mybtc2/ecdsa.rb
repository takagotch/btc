# gem install ecdsa
# gem install bitcoin
# irb

require 'openssl'
ecdsa = OpenSSL::PKey::EC.new('secp256k1')
key = ecdsa.generate_key
key.privat_key.to_i

require 'securerandom'
SecureRandom.hex(32)

require 'ecdsa'
group = ECDSA::Group::Secp256k1

# https://www.rubydoc.info/gems/ecdsa/ECDSA/Point

require 'bitcoin'
Bitcoin.network = :testnet3
key = Bitcoin::generate_key


require 'digest'
message = "txt"
Digest::SHA256.digest(message)
Digest::RMD160.digest(message)

require 'securerandom'
nonce = SecureRandom.hex(32)
commitment = Digest::SHA256.digest(nonce + message)

require 'openssl'
curves = OpenSSL::PKey::EC.builtin_curves

require 'esdsa'
group = ECDSA::Group::Secp256k1
prime=group.field.prime
group.generator.x
group.generator.y
group.param_a
group.param_b
group.order


require 'ecdsa'
group = ECDSA::Group::Secp256k1
G=group.generator
G.multiply_by_scalar(3)
G*3
n=group.order
G*n
(G*n).infinity?
(G*(n+1)).infinity?
(G*(n+1))==G
p=G*4
q=G*7
p.add_to_point(q)
r=p+q
s=p.negate
(p+s).infinity?
p.x
s.x
p.y
s.y
prime=group.field.prime
(prime - p.y) == s.y


require 'esdsa'
require 'securerandom'

group = ECDSA::Group::Secp256k1
n = group.order
privKey = 1 + SecureRandom.random_number(n-1)
pubKey = group.generator.multiply_by_scalar(privKey)
G = group.generator
pubkey_simple = G*privKey
pubkey_eql>(pubkey_simple)
pubKey.x
pubKey.y

require 'bitcoin'
key = Bitcoin::generate_key
privKey=key[0]
pubKey=key[1]


require 'openssl'
ec = OpenSSL::PKey::EC.new('secp256k1')
key=ec.generate_key
privKey = key.private_key.to_i
pubKey = key.public_key.to_bn.to_i


require 'digest'
require 'securerandom'
require 'ecdsa'

group = ECDSA::Group::Secp256k1
n = group.order
privKey = 1 + SecureRandom.random_number(n-1)
pubKey = group.generator.multiply_by_scalar(privKey)

message = "txt"
digest = Digest::SHA256.hexdigest(message)

k = 1 + SecureRandom.random_number(n-1)
sign = EDSA.sign(group,privKey,digest,k)

sign.r
sign.s


der_sign = ECDSA::Format::SignatureDerString.encode(sign)


digest = OpenSSL::Digest::SHA256.hexdigest(message)
sign = ECDSA::Format::SignatureDerString.decode(der_sign)

ECDSA.valid_signature?(pubKey, digest, sign)


require 'openssl'
ec = OpenSSL::PKey::EC.new('secp256k1')

key=ec.generate_key
message = "txt"
digest = key.dsa_sign_asn1(digest)
sign = key.dsa_sign_asn1(digest)

key.dsa_verify_asn1(digest,sign)


A = "xxx"
remain = ->n(n<58 ? A[n] : [remain[n/58],A[n%58]])
base58encode = ->h{remain[h.hex].flatten.join}

base58encode["xxx"]


A = "xxx"
base58decode = ->b{b.reverse.split('').map.with_index{|c,i| A.index(c)*58**i}.reduce(:+).to_s(16)}

base58decode["xxx"]



require 'bitcoin'
key = Bitoin::generate_key
pubKey = [key[1]].pack("H*")

include Digest
payload = RMD160.hexdigest(SHA256.digest(pubKey))

payload6f = ['6f'+ payload].pack("H*")

checksum = SHA256.hexdigest(SHA256.digest(payload6f) )[0..8]

address = Bitcoin::encode_base58('6f' + payload +checksum)

payload00 = ['00'+ payload].pack("H*")

checksum = SHA256.hexdigest(SHA256.digest(payload00) )[0..8]

address = Bitcoin::encode_base58('00' + payload + checksum)


Bitcoin::network = :testnet3
address = Bitcoin::pubkey_to_address(key[1])

Bitcoin::network = :bitcoin

address = Bitcoin::pubkey_to_address(key[1])

require 'bitcoin'
base58data = "xxx"

Bitcoin.base58_checksum?(base58data)

x = "xxx"
y = "xxx"
pubKey = "04" + x + y

pubKey


x = "xxx"
y = "xxx"
compresed_pubKey = "03" + x

x = "xxx"
y = "xxx"
compressed_pubKey = "02" + x

to_compressed_pubKey = -> pk{(pk.to_i(16).odd? ? "03"+pk[2..65] : "02"+pk[2..65])}

pubKey1 = "xxx"
pubKey2 = "xxx"
to_compressed_pubKey[pubKey1]
to_compressed_pubKey[pubKey2]


