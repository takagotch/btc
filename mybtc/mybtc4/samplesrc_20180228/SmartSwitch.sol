pragma solidity ^0.4.11;
contract SmartSwitch {
	// �X�C�b�`�p�̍\����
	struct Switch {
		address addr;	// ���p�҂̃A�h���X
		uint	endTime;	// ���p�I�������iUnixTime�j
		bool 	status;	// true�̏ꍇ�͗��p�\
	}
	
	address public owner;	// �T�[�r�X�I�[�i�[�̃A�h���X	
	address public iot;	// IoT�̃A�h���X
		
	mapping (uint => Switch) public switches;	// Switch���i�[����}�b�v
	uint public numPaid;			// �x�������s��ꂽ��
	
	/// �T�[�r�X�I�[�i�[�̌����`�F�b�N
	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	
	/// IoT�̌����`�F�b�N
	modifier onlyIoT() {
		require(msg.sender == iot);
		_;
	}
	
	/// �R���X�g���N�^
	/// IoT�̃A�h���X�������Ɏ��
	function SmartSwitch(address _iot) {
		owner = msg.sender;
		iot = _iot;
		numPaid = 0;
	}

	/// �x�������ɌĂ΂��֐�
	function payToSwitch() public payable {
		// 1 ether�łȂ���Ώ������I������
		require(msg.value == 1000000000000000000);
		
		// Switch��ݒ肷��
		Switch s = switches[numPaid++];
		s.addr = msg.sender;
		s.endTime = now + 300;
		s.status = true;
	}
	
	/// status��ύX����֐�
	/// ���p�I�������ɂȂ�����Ăяo�����
	/// ������switches��key�l
	function updateStatus(uint _index) public onlyIoT {
		// �Ώۂ�index�ɑ΂���Switch���ݒ肳��Ă��Ȃ���Ώ������I������
		require(switches[_index].addr != 0);
		
		// ���p�I�������ɒB���Ă��Ȃ���Ώ������I������
		require(now > switches[_index].endTime);
		
		// status���X�V����
		switches[_index].status = false;
	}

	/// �x����ꂽether�������o�����߂̊֐�	
	function withdrawFunds() public onlyOwner {
		if (!owner.send(this.balance)) 
			throw;
	}
	
	/// �R���g���N�g��j�����邽�߂̊֐�
	function kill() public onlyOwner {
		selfdestruct(owner);
	}
}
