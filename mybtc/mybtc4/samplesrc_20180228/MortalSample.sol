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

contract Mortal is Owned {
	/// �R���g���N�g��j�����āAether��owner�ɑ���
	function kill() public onlyOwner {
		selfdestruct(owner);
	}
}

contract MortalSample is Mortal{
	string public someState;
	
	/// Fallback�֐�
	function() payable {
	}
	
	/// �R���X�g���N�^
	function MortalSample() {
		// Owned�Œ�`����Ă���owned�֐����Ăяo��
		owned();
		
		// someState�̏����l��ݒ�
		someState = "initial";
	}
}