pragma solidity ^0.4.11;
contract Lottery {
	// 応募者を管理
	mapping (uint => address) public applicants;

	// 応募者数を管理
	uint public numApplicants;

	// 抽選者情報
	address public winnerAddress;
	uint public winnerInd;
	
	// オーナー
	address public owner;

	// タイムスタンプ
	uint public timestamp;
	
	/// ownerチェック用のmodifier
	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	
	/// コンストラクタ
	function Lottery() {
		numApplicants = 0;
		owner = msg.sender;
	}

	/// 抽選に申し込むための関数
	function enter() public {
		// 応募者数が3人を超えていた場合は処理を終了
		require(numApplicants < 3);
		
		// すでに応募済みであれば処理を終了
		for(uint i = 0; i < numApplicants; i++) {
			require(applicants[i] != msg.sender);
		}
		
		// 応募を受け付ける
		applicants[numApplicants++] = msg.sender;
	}
	
	/// 抽選を行う
	function hold() public onlyOwner {
		// 応募者が3人に達していない場合は処理を終了
		require(numApplicants == 3);
		
		// タイムスタンプを設定
		timestamp = block.timestamp;
		
		// 抽選
		winnerInd = timestamp % 3;
		winnerAddress = applicants[winnerInd];
	}

}