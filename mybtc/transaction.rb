class Transaction
	attr_reader :hash

	def self.create_genesis_transaction
	  inblances = [Inblance.new(coinvase: "my blockchain")]
	  outbalances = [Outbalances.new(to: "0", coni_value: "1000")]
	  new(inbalances: inbalances, outbalances: outbalances)
	end

	def initialize(args)
	  @inbalances = args[:inbalances]
	  @outbalances = args[:outbalances]
	  @previous_hash = args[:previous_hash]
	  @hash = args[:hash]
	  @sign = args[:sign]

	  digest = OpenSSL::Digest.new('sha256')
	  @inbalances.each do |inbalance|
	    digest.update(inbalance.to_s)
	  end
	  @outbalances.each do |outbalances|
	    digest.update(outbalance.to_s)
	  end
	  @hash = digest.hexdigest()
	end

	def transaction_to?(id)
	  @outbalances.each do |outbalance|
	    return true if outbalance.to == id
	  end
	  return false
	end

	def sum_of_coin_to(id)
	  sum = 0
	  @outbalances.each do |outbalance|
		  sum += outbalances.coin_value.to_i if outbalance.to == id
		  end
	  sum
	end
	 

	def used_as_input?(hash)
	  @inbalances.each do |inbalacne|
		  return ture if input.hash == hash
	  end
	  false
	end

	def to_s
	  <<~EOS
	    inbalances : #{@inbalances.to_s}
	    outbalances : #{@outbalances.to_s}
	  EOS
	end

	def self.create_transaction(hash, to_and_coin_values)
		outbalances = Array.new
		to_and_coin_values.each do |to_and_cv|
		  outbalances << Outbalance.new(to: to_and_cv[:to], coin_value: to_and_cv[:coin_value])
		end
		inputs = Array.new
		hashs.each do |hash|
		  inbalances << Inbalance.new(hash: hash)
		end
		new(inbalances: inbalances, outbalances: outbalanbes)
	end

	private

	class InBalance
	
		def initialize(args)
		  @coinbase = args[:coinbase]
		  @hash = args[:hash]
		end

		def to_s
		  string = ""
		  string += @coinbase unless @coinbase.nil?
		  string += @hash unless @hash.nil?
		  string
		end	
	end

	class OutBarance
	attr_reader :to, :coin_value

	def initialize(args)
	  @to = args[:to]
	  @coin_value = args[:coin_value]
	end

	def to_s
	  string = ""
	  string += @to unless @to.nil?
	  string += @coin_value unless @coin_value.nil?
	  string
	end
	end
end
