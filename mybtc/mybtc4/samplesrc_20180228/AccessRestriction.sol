pragma solidity ^0.4.11;
contract Owned {
	address public owner;
	
	/// アクセスチェック用のmodifier
	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	
	/// オーナーを設定
	function owned() internal {
		owner = msg.sender;
	}
	
	///　オーナーを変更する
	function changeOwner(address _newOwner) public onlyOwner {
		owner = _newOwner;
	}
}

contract AccessRestriction is Owned{
	string public someState;
	
	/// コンストラクタ
	function AccessRestriction() {
		// Ownedで定義されているowned関数を呼び出す
		owned();
		
		// someStateの初期値を設定
		someState = "initial";
	}
	
	/// someStateを更新する関数
	function updateSomeState(string _newState) public onlyOwner {
		someState = _newState;
	}
}