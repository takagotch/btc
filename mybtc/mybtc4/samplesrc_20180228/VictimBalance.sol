pragma solidity ^0.4.11;
contract  VictimBalance {
	// アドレス毎に残高を管理
	mapping (address => uint) public userBalances;

	// メッセージ表示用のイベント
	event MessageLog(string);
	
	// 残高表示用のイベント
	event BalanceLog(uint);

	/// コンストラクタ
	function VictimBalance() {
	}

	/// 送金される際に呼ばれる関数
	function addToBalance() public payable {
		userBalances[msg.sender] += msg.value;
	}

	/// etherを引き出す時に呼ばれる関数
	function withdrawBalance() public payable returns(bool) {
		MessageLog("withdrawBalance started.");
		BalanceLog(this.balance);
		
		// ①残高を確認
		if(userBalances[msg.sender] == 0) {
			MessageLog("No Balance.");
			return false;
		}
		
		// ②呼出し元に返金
		if (!(msg.sender.call.value(userBalances[msg.sender])())) { throw; }
		
		// ③残高を更新
		userBalances[msg.sender] = 0;
		
		MessageLog("withdrawBalance finished.");
		
		return true;
	}
}