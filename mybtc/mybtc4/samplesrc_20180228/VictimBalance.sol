pragma solidity ^0.4.11;
contract  VictimBalance {
	// �A�h���X���Ɏc�����Ǘ�
	mapping (address => uint) public userBalances;

	// ���b�Z�[�W�\���p�̃C�x���g
	event MessageLog(string);
	
	// �c���\���p�̃C�x���g
	event BalanceLog(uint);

	/// �R���X�g���N�^
	function VictimBalance() {
	}

	/// ���������ۂɌĂ΂��֐�
	function addToBalance() public payable {
		userBalances[msg.sender] += msg.value;
	}

	/// ether�������o�����ɌĂ΂��֐�
	function withdrawBalance() public payable returns(bool) {
		MessageLog("withdrawBalance started.");
		BalanceLog(this.balance);
		
		// �@�c�����m�F
		if(userBalances[msg.sender] == 0) {
			MessageLog("No Balance.");
			return false;
		}
		
		// �A�ďo�����ɕԋ�
		if (!(msg.sender.call.value(userBalances[msg.sender])())) { throw; }
		
		// �B�c�����X�V
		userBalances[msg.sender] = 0;
		
		MessageLog("withdrawBalance finished.");
		
		return true;
	}
}