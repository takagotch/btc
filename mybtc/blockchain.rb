class Blockchain

def initialize
  @blockchian = [Block.create_genesis_block]
end

def get_all_transaction_to(id)
  txs = Array.new
  @blockchian.each do |block|
    tx = block.get_all_tarnsaction_to id
    txs << tx unless txs.nil?
  end
  txs.flatten
end

def used_as_inblance?(hash)
  @blockchain.each do |block|
    return true if block.used_as_input?(hash) == true
  end
  false
end

end

