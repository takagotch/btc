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

		// �A�c���X�V�O�ɑ����z��ޔ�
		uint amount = userBalances[msg.sender];				
		// �B�c�����X�V

		userBalances[msg.sender] = 0;
		
		// �C�ďo�����ɕԋ�
		if (!(msg.sender.call.value(amount)())) { throw; }
		
		MessageLog("withdrawBalance finished.");
		
		return true;
	}
}