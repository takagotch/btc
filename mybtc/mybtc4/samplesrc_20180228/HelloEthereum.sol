pragma solidity ^0.4.11;
contract HelloEthereum {
:	// コメント例①
	string public msg1;	
	
	string private msg2; // コメント例②
	
	/* コメント例③ */
	address public owner;
	
	uint8 public counter;
	
	/// コンストラクタ
	function HelloEthereum(string _msg1) {
		// msg1に _msg1を設定
		msg1 = _msg1;
		
		// ownerに本コントラクトを生成したアドレスを設定する
		owner = msg.sender;
		
		// counterに初期値として0を設定
		counter = 0;
	}
	
	/// msg2のsetter
	function setMsg2(string _msg2) public {
		// if文の例
		if(owner != msg.sender) {
			throw;
		} else {
			msg2 = _msg2;	
		}
	}
	
	// msg2のgetter
	function getMsg2() constant public returns(string) {
		return msg2;
	}
	
	function setCounter() public {
		// for文の例
		for(uint8 i = 0; i < 3; i++) {
			counter++;
		}
	}
}