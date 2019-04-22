pragma solidity ^0.4.11;
contract CircuitBreaker {
	bool public stopped;	// trueの場合、Circuit Breakerが発動している
	address public owner;		
	bytes16 public message;

	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}

	/// stopped変数を確認するmodifier	
	modifier isStopped() {
		require(!stopped);
		_;
	}

	/// コンストラクタ
	function CircuitBreaker() {
		owner = msg.sender;
		stopped = false;
	}
	
	/// stoppedの状態を変更
	function toggleCircuit(bool _stopped) public onlyOwner {
		stopped = _stopped;
	}
		
	/// messageを更新する関数
	/// stopped変数がtrueの場合は更新出来ない
	function setMessage(bytes16 _message) public isStopped {
		message = _message;
	}
}