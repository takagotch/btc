pragma solidity ^0.4.11;
contract Auction {
	address public highestBidder;	// 最高額提示アドレス
	uint public highestBid;	// 最高提示額
	
	/// コンストラクタ
	function Auction() payable {
		highestBidder = msg.sender;
		highestBid = 0;
	}
	
	/// Bid用の関数
	function bid() public payable {
		// bidが現在の最高額よりも大きいことを確認する
		require(msg.value > highestBid);
		
		// 返金額退避
		uint refundAmount = highestBid;
		
		// 最高額提示アドレス退避
		address currentHighestBidder = highestBidder;
		
		// ステート更新
		highestBid = msg.value;
		highestBidder = msg.sender;
		
		// 最高額を提示していたbidderに返金する
		if(!currentHighestBidder.send(refundAmount)) {
			throw;
		}
	}
}