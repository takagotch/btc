pragma solidity ^0.4.11;
contract Lottery {
	// ����҂��Ǘ�
	mapping (uint => address) public applicants;

	// ����Ґ����Ǘ�
	uint public numApplicants;

	// ���I�ҏ��
	address public winnerAddress;
	uint public winnerInd;
	
	// �I�[�i�[
	address public owner;

	// �^�C���X�^���v
	uint public timestamp;
	
	/// owner�`�F�b�N�p��modifier
	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	
	/// �R���X�g���N�^
	function Lottery() {
		numApplicants = 0;
		owner = msg.sender;
	}

	/// ���I�ɐ\�����ނ��߂̊֐�
	function enter() public {
		// ����Ґ���3�l�𒴂��Ă����ꍇ�͏������I��
		require(numApplicants < 3);
		
		// ���łɉ���ς݂ł���Ώ������I��
		for(uint i = 0; i < numApplicants; i++) {
			require(applicants[i] != msg.sender);
		}
		
		// ������󂯕t����
		applicants[numApplicants++] = msg.sender;
	}
	
	/// ���I���s��
	function hold() public onlyOwner {
		// ����҂�3�l�ɒB���Ă��Ȃ��ꍇ�͏������I��
		require(numApplicants == 3);
		
		// �^�C���X�^���v��ݒ�
		timestamp = block.timestamp;
		
		// ���I
		winnerInd = timestamp % 3;
		winnerAddress = applicants[winnerInd];
	}

}