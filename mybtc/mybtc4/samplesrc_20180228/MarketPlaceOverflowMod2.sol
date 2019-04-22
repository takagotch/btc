pragma solidity ^0.4.11;
contract MarketPlaceOverflowMod2 {
	address public owner;
	uint8 public stockQuantity;	// 在庫数
	
	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	
	/// 追加在庫数を表示するイベント
	event AddStock(uint8 _addedQuantity);
			
	/// コンストラクタ
	function MarketPlaceOverflowMod2() {
		owner = msg.sender;
		stockQuantity = 100;
	}
	
	/// 在庫の追加処理
	function addStock(uint8 _addedQuantity) public onlyOwner {
		// 追加数のチェック
		require(_addedQuantity < 256);
		
		// オーバーフローチェック
		require(stockQuantity + _addedQuantity > stockQuantity);
		
		AddStock(_addedQuantity);
		stockQuantity += _addedQuantity;
	}
}