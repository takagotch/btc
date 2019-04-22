pragma solidity ^0.4.11;
contract AuctionWithdraw {
	address public highestBidder;	// 最高額提示アドレス
	uint public highestBid;	// 最高提示額
	mapping(address => uint) public userBalances;	// 返金額を管理するマップ
	
	/// コンストラクタ
	function AuctionWithdraw() payable {
		highestBidder = msg.sender;
		highestBid = 0;
	}
	
	/// Bid用の関数
	function bid() public payable {
		// bidが現在の最高額よりも大きいことを確認する
		require(msg.value > highestBid);

		// 最高額提示アドレスの返金額を更新する
		userBalances[highestBidder] += highestBid;
				
		// ステート更新
		highestBid = msg.value;
		highestBidder = msg.sender;
	}
	
	function withdraw() public{
		// 返金額が0より大きいことを確認する
		require(userBalances[msg.sender] > 0);
		
		// 返金額を退避
		uint refundAmount = userBalances[msg.sender];
		
		// 返金額を更新
		userBalances[msg.sender] = 0;
		
		// 返金処理
		if(!msg.sender.send(refundAmount)) {
			throw;
		}
	}
}