pragma solidity ^0.4.3;
contract SolidityOverflow {
	uint8 public first;
	uint8 public second;
	address public owner;
	uint256 public third;
	uint256 public fourth;

	/// コンストラクタ
	function SolidityOverflow() {
		first = 1;
		second = 2;
		third = 3;
		fourth = 4;
		owner = msg.sender;
	}
	
	/// firstのセッター
	function setFirst(uint8 _first) public {
		first = _first;
	}
	
	/// thirdのセッター
	function setThird(uint8 _third) public {
		if(msg.sender != owner) {
			throw;
	    }
		third = _third;
	}
}