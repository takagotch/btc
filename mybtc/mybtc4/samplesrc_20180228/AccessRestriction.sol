pragma solidity ^0.4.11;
contract Owned {
	address public owner;
	
	/// �A�N�Z�X�`�F�b�N�p��modifier
	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	
	/// �I�[�i�[��ݒ�
	function owned() internal {
		owner = msg.sender;
	}
	
	///�@�I�[�i�[��ύX����
	function changeOwner(address _newOwner) public onlyOwner {
		owner = _newOwner;
	}
}

contract AccessRestriction is Owned{
	string public someState;
	
	/// �R���X�g���N�^
	function AccessRestriction() {
		// Owned�Œ�`����Ă���owned�֐����Ăяo��
		owned();
		
		// someState�̏����l��ݒ�
		someState = "initial";
	}
	
	/// someState���X�V����֐�
	function updateSomeState(string _newState) public onlyOwner {
		someState = _newState;
	}
}