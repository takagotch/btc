pragma solidity ^0.4.11;
contract NameRegistry {

	// コントラクト用の構造体
	struct Contract {
		address owner;
		address addr;
		bytes32 description;
	}

	// 登録済みのレコード数
	uint public numContracts;

	// コントラクトを保持するマップ
	mapping (bytes32  => Contract) public contracts;
    
	/// コンストラクタ
	function NameRegistry() {
		numContracts = 0;
	}

	/// コントラクトを登録する
	function register(bytes32 _name) public returns (bool){
		// 名前が利用されていなければ登録する
		if (contracts[_name].owner == 0) {
			Contract con = contracts[_name];
			con.owner = msg.sender;
			numContracts++;
			return true;
		} else {
			return false;
		}
	}

	/// コントラクトを削除する
	function unregister(bytes32 _name) public returns (bool) {
		if (contracts[_name].owner == msg.sender) {
			contracts[_name].owner = 0;
 			numContracts--;
 			return true;
		} else {
			return false;
		}
	}
	
	/// コントラクトのオーナーを変更する
	function changeOwner(bytes32 _name, address _newOwner) public onlyOwner(_name) {
		contracts[_name].owner = _newOwner;
	}
	
	/// コントラクトのオーナーを取得する
	function getOwner(bytes32 _name) constant public returns (address) {
		return contracts[_name].owner;
	}
    
	/// コントラクトのアドレスをセットする
	function setAddr(bytes32 _name, address _addr) public onlyOwner(_name) {
		contracts[_name].addr = _addr;
    }
    
	/// コントラクトのアドレスを取得する
	function getAddr(bytes32 _name) constant public returns (address) {
		return contracts[_name].addr;
	}
        
	/// コントラクトの説明を設定する
	function setDescription(bytes32 _name, bytes32 _description) public onlyOwner(_name) {
		contracts[_name].description = _description;
	}

	/// コントラクトの説明を取得する
	function getDescription(bytes32 _name) constant public returns (bytes32)  {
		return contracts[_name].description;
	}
    
	/// 関数呼出し前に呼び出される処理であるmodifierを定義
	modifier onlyOwner(bytes32 _name) {
	    require(contracts[_name].owner == msg.sender);
		_;
	}
}
