require 'bitcoin'
require 'eventmachine'

Bitcoin.network = :testnet3

class Connection < EM::Connection

  attr_reader :host, :port, :parser

  def initialize(host, port)
    @host = host
    @port = port
    @parser = Bitcoin::Protocol::Parser.new( self )
  end

  def post_init
    puts "connected."
    on_handshake_begin
  end

  def receive_data(data)
    parser.parser(data)
  end

  def on_handshake_begin
    puts "handshake begin."

    params = {block: 0, from: "127.0.0.1:18333", nonce: Bitcoin::Protocol::Uniq, "#{host}:#{port}",
      user_agent: "/bitcoin-ruby:#{Bitcoin::VERSION}/", version: 70015, time: Time.now.tv_sec}
    send_data(Bitcoin::Protocol.version_pkt(params))
  end

  def on_version(version)
    puts "receive version. Version:#{version.version}, UserAgent: #{version.user_agent}"
  end

  def on_verack
    puts "receive verack. handshake complete."
  end
end

EM.run do
  EM.connect('localhost', 18333, Connection, 'localhost', 18333)
end


require 'murmurhash3'

class BloomFilter
  
  SEED_BASE = 0xFBA4C795

  attr_reader :bits
  attr_reader :hash_funcs
  attr_reader :tweak

  def initialize(n, k, tweak)
    @bits = Array.new(n, 0)
    @tweak = tweak
    @hash_funcs = k
  end

  def add(data)
    calc_index(data).each do |i|
      bits[i] = 1
    end
  end

  def contains?(data)
    calc_index(data).map{|i|bits[i]}.find{|i| i == 0}.nil?
  end

  private

  def calc_index(data)
    list = []
    hash_funcs.times do |i|
      seed = (i * SEED_BASE + tweak) & 0xfffffff
      hash = MurmurHash3::V32.str_hash(data, seed)
      list << hash % bits.length
    end
    list
  end
end


filter = BloomFilter.new(10, 2, 123456)

filter.add('bitcoin')
filter.add('monacoin')

filter.contains?('litecoin')

filter.contains?('bitcoin4')

