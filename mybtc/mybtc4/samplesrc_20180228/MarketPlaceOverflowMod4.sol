pragma solidity ^0.4.11;
contract MarketPlaceOverflowMod4 {
	address public owner;
	uint public stockQuantity;	// 在庫数
	
	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	
	/// 追加在庫数を表示するイベント
	event AddStock(uint _addedQuantity);
			
	/// コンストラクタ
	function MarketPlaceOverflowMod4() {
		owner = msg.sender;
		stockQuantity = 0;
	}
	
	/// 在庫の追加処理
	function addStock(uint _addedQuantity) public onlyOwner {
		// オーバーフローチェック
		require(stockQuantity + _addedQuantity > stockQuantity);
		
		AddStock(_addedQuantity);
		stockQuantity += _addedQuantity;
	}
}