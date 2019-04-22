pragma solidity ^0.4.11;
contract CrowdFunding {
	// ������
	struct Investor {
		address addr;	// �����Ƃ̃A�h���X
		uint amount;	// �����z
	}
	
	address public owner;		// �R���g���N�g�̃I�[�i�[
	uint public numInvestors;	// �����Ƃ̐�
	uint public deadline;		// ���ߐ؂�(UnixTime)
	string public status;		// �L�����y�[���̃X�e�[�^�X
	bool public ended;			// �L�����y�[�����I�����Ă��邩�ǂ���
	uint public goalAmount;		// �ڕW�z
	uint public totalAmount;	// �����̑��z
	mapping (uint => Investor) public investors;	// �����ƊǗ��p�̃}�b�v 
	
	modifier onlyOwner () {
		require(msg.sender == owner);
		_;
	}
	
	/// �R���X�g���N�^
	function CrowdFunding(uint _duration, uint _goalAmount) {
		owner = msg.sender;

		// ���ߐ؂��UnixTime�Őݒ�
		deadline = now + _duration;

		goalAmount = _goalAmount;
		status = "Funding";
		ended = false;

		numInvestors = 0;
		totalAmount = 0;
	}
	
	/// ��������ۂɌĂяo�����֐�
	function fund() payable {
		// �L�����y�[�����I����Ă���Ώ����𒆒f����
		require(!ended);
		
		Investor inv = investors[numInvestors++];
		inv.addr = msg.sender;
		inv.amount = msg.value;
		totalAmount += inv.amount;
	}
	
	/// �ڕW�z�ɒB���������m�F����
	/// �܂��A�L�����y�[���̐���/���s�ɉ�����ether�̑������s��
	function checkGoalReached () public onlyOwner {		
		// �L�����y�[�����I����Ă���Ώ����𒆒f����
		require(!ended);
		
		// ���ߐ؂�O�̏ꍇ�͏����𒆒f����
		require(now >= deadline);
		
		if(totalAmount >= goalAmount) {	// �L�����y�[���ɐ��������ꍇ
			status = "Campaign Succeeded";
			ended = true;
			// �I�[�i�[�ɃR���g���N�g���̂��ׂĂ�ether�𑗋�����
			if(!owner.send(this.balance)) {
				throw;
			}
		} else {	// �L�����y�[���Ɏ��s�����ꍇ
			uint i = 0;
			status = "Campaign Failed";
			ended = true;
			
			// �����Ɩ���ether��ԋ�����
			while(i <= numInvestors) {
				if(!investors[i].addr.send(investors[i].amount)) {
					throw;
				}
				i++;
			}
		}
	}
	
	/// �R���g���N�g��j�����邽�߂̊֐�
	function kill() public onlyOwner {
		selfdestruct(owner);
	}
}