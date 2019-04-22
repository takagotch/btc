pragma solidity ^0.4.11;
contract MarketPlaceTOD {
	address public owner;
	uint public price;	// 1つあたりの金額
	uint public stockQuantity;	// 在庫数
	
	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	
	event UpdatePrice(uint _price);
	event Buy(uint _price, uint _quantity, uint _value, uint _change);
	
	/// コンストラクタ
	function MarketPlaceTOD() {
		owner = msg.sender;
		price = 1;
		stockQuantity = 100;
	}
	
	/// 金額の更新処理
	function updatePrice(uint _price) public onlyOwner {
		price = _price;
		UpdatePrice(price);
	}

	/// 購入処理
	function buy(uint _quantity) public payable {
		if (msg.value < _quantity * price || _quantity > stockQuantity) {
			throw;
		}
		
		// お釣りを返す処理
		if(!msg.sender.send(msg.value - _quantity * price)) {
			throw;	
		}
		
		stockQuantity -= _quantity;
		Buy(price, _quantity, msg.value, msg.value - _quantity * price);
	}	
}