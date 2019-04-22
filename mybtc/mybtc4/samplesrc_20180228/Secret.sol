pragma solidity ^0.4.11;
contract Secret {
	string private secret;	// 秘密の文字列
	
	/// コンストラクタ
	function Secret(string _secret) {
		secret = _secret;
	}
	
	/// 秘密の文字列を設定
	function setSecret(string _secret) public {
		secret = _secret;
	}
}