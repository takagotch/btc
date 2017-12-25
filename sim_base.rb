require_relative 'lib/block_chain'
require_relative 'lib/miner'

$receive_block_chain = BlockChain.new

def create_miner args
  Thread.new {
    miner = Miner.new args
    3.times do
	    sleep [1, 2, 3].sample
	    miner.accept $receive_block_chain
	    [1, 2, 3].sample.times.each do |i|
	      miner.add_new_block
	    end
	    broadcast miner
    end
  }
end

def broadcast miner
  puts "#{miner.name} broadcasted"
  $received_block_chain = miner.block_chain
end

puts "start"
th1 = create_miner name: "miner1"
th2 = create_miner name: "miner2"
th3 = create_miner name: "miner3"
[th1, th2, th3].each{|t| t.join}

puts "block chain result"

$receive_block_chain.blocks.each{|block| puts block.data}

