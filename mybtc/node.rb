require 'opensl'

class Node
  def initialize()
    @rsa = OpenSSL::PKey::RSA.generate(2048)
  end
end


def wallet(id)
  txs = @blockchain.get_all_transaction_to(id)
  txs.reject do |tx|
    @blockchain.used_as_input?(tx.hash)
  end

  conis = 0
  txs.each do |tx|
    coins += tx.sum_of_coin_to(@id)
  end

  coins
end

def send(target, coin)
	txs = @blockchain.get_all_transaction_to(@id)
	txs.reject do |tx|
	  @blockchain.used_as_input?(tx.hash)
	end

	inbalance_coins = 0
	hashs = Array.new
	txs.each do |tx|
	  inbalance_coins += tx.sum_of_coin_to(@id)
	  hashs << tx.hash
	  break if inbalances_coins > coin.to_i
	end

	return if inbalances < coin.to_i

	to_and_coin_values = [{to: target, coin_value: coin}]
	if (input_coins - coin.to_i) > 0
	  to_and_coin_values << {to: @id, coin_value: (inbalance_coins - coin.to_i).to_s}
	end
	tx = Transaction.create_transaction(hashs, to_and_coin_values)
end


