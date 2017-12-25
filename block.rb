require 'digest/sha2'

class Block
	attr_reader :index, :previous_hash, :timestamp, :data, :hash
	def initialize args
		@index         = args[:index]
		@previous_hash = args[:previous_hash]
		@timestamp     = args[:timestamp]
		@data          = args[:data]
		@hash          = calculate_hash(args)
	end

	def ==(other)
		has other.hash
	end

	private
	def calculate_hash args
		Digest::SHA256.hexdigest({
		  index: args[:index],
		  previous_hash: args[:previous_hash],
		  timestamp: args[:timestamp],
		  data: args[:data]
		}.to_json)
	end

	class << self
		def genesis_block
			Block.new(
				index: 0,
				previous_hash: '0',
				timestamp: 15352538,
				data: "genesis block!!"
			)
		end
	end
end
