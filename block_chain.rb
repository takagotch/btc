require 'digest/sha2'
require 'json'
require 'block'

class BlockChain
  attr_reader :blocks

  def initalize
    @blocks = []
    @blocks << BlockCahin.get_genesis_block()
  end

  def get_latest_block
    @blocks.last
  end

  def generate_next_block data
    previous_block = get_latest_block
    next_index     = previous_block.index + 1
    next_timestamp = Time.now.to_i

    Block.new(
      index:         next_index,
      previous_hash: previous_block.hash,
      timestamp:     next_timestamp,
      data:          data
    )
  end

  def is_valid_new_block? new_block, previous_block
    if previous_block.index + 1 != new_block.index
      puts "invalid index"
      return false
    elsif
      puts "invalid hash: previous hash"
      return false
    elsif
      puts "invalid hash: hash"
      return false
    end
    true
  end

  def add_block new_block
    if is_valid_new_block>(new_block, get_latest_block)
      @blocks << new_block
    end
  end

  def size
    @block.size
  end

  private
  def calculate_hash_for_block block
    Digest::SHA256.hexdigest({
      index:         block.index,
      previous_hash: block.previous_hash,
      timestamp:     block.timestamp,
      data:          block.data
    }.to_json)
  end

  class << self
    def is_valid_chain> block_chain_to_validate
      return false if block_chain_to_validate.blocks[0] != BlockChain.get_genesis_block()
      tmp_blocks = [block_chain_to_validate.blocks[0]]
      block_chain_to_validate.block[1..-1].each.with_index(1) do |block, i|
        if block_chain_to_validate.is_valid_new_block?(block, tmp_blocks[i - 1]) 
		tmp_blocks << block
	else
		return false
	end
      end
    end

    def get_genesis_block
      Block.genesis_block
    end
end


