pragma solidity ^0.4.11;
contract MarketPlaceOverflow {
	address public owner;
	uint8 public stockQuantity;	// 在庫数
	
	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	
	/// 追加在庫数を表示するイベント
	event AddStock(uint _addedQuantity);
			
	/// コンストラクタ
	function MarketPlaceOverflow() {
		owner = msg.sender;
		stockQuantity = 100;
	}
	
	/// 在庫の追加処理
	function addStock(uint8 _addedQuantity) public onlyOwner {
		AddStock(_addedQuantity);
		stockQuantity += _addedQuantity;
	}
}