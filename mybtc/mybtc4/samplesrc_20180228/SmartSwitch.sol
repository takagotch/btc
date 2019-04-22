pragma solidity ^0.4.11;
contract SmartSwitch {
	// スイッチ用の構造体
	struct Switch {
		address addr;	// 利用者のアドレス
		uint	endTime;	// 利用終了時刻（UnixTime）
		bool 	status;	// trueの場合は利用可能
	}
	
	address public owner;	// サービスオーナーのアドレス	
	address public iot;	// IoTのアドレス
		
	mapping (uint => Switch) public switches;	// Switchを格納するマップ
	uint public numPaid;			// 支払いが行われた回数
	
	/// サービスオーナーの権限チェック
	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	
	/// IoTの権限チェック
	modifier onlyIoT() {
		require(msg.sender == iot);
		_;
	}
	
	/// コンストラクタ
	/// IoTのアドレスを引数に取る
	function SmartSwitch(address _iot) {
		owner = msg.sender;
		iot = _iot;
		numPaid = 0;
	}

	/// 支払い時に呼ばれる関数
	function payToSwitch() public payable {
		// 1 etherでなければ処理を終了する
		require(msg.value == 1000000000000000000);
		
		// Switchを設定する
		Switch s = switches[numPaid++];
		s.addr = msg.sender;
		s.endTime = now + 300;
		s.status = true;
	}
	
	/// statusを変更する関数
	/// 利用終了時刻になったら呼び出される
	/// 引数はswitchesのkey値
	function updateStatus(uint _index) public onlyIoT {
		// 対象のindexに対してSwitchが設定されていなければ処理を終了する
		require(switches[_index].addr != 0);
		
		// 利用終了時刻に達していなければ処理を終了する
		require(now > switches[_index].endTime);
		
		// statusを更新する
		switches[_index].status = false;
	}

	/// 支払われたetherを引き出すための関数	
	function withdrawFunds() public onlyOwner {
		if (!owner.send(this.balance)) 
			throw;
	}
	
	/// コントラクトを破棄するための関数
	function kill() public onlyOwner {
		selfdestruct(owner);
	}
}
