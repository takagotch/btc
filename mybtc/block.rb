class Block

def self.create_genesis_block
  Block.new(timestamp: Time.utc(2017,12,27), transactions:[Transaction.create_genesis_transaction])
end

def initialize(args)
  @timestamp = args[:timestamp]
  @transactions = args[:transactions]
  @hash = args[:hash]
  @previous_hash = args[:previous_hash]
end

def get_all_transaction_to(id)
  @transactions.select do |tx|
    tx.transaction_to? id
  end
end

def used_as_inbalance?(hash)
  @transactions.each do |tx|
    return true if tx.used_as_inbalance(hash) == true
  end
  false
end

end
