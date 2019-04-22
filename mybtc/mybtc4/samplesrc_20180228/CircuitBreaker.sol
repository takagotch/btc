pragma solidity ^0.4.11;
contract CircuitBreaker {
	bool public stopped;	// true�̏ꍇ�ACircuit Breaker���������Ă���
	address public owner;		
	bytes16 public message;

	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}

	/// stopped�ϐ����m�F����modifier	
	modifier isStopped() {
		require(!stopped);
		_;
	}

	/// �R���X�g���N�^
	function CircuitBreaker() {
		owner = msg.sender;
		stopped = false;
	}
	
	/// stopped�̏�Ԃ�ύX
	function toggleCircuit(bool _stopped) public onlyOwner {
		stopped = _stopped;
	}
		
	/// message���X�V����֐�
	/// stopped�ϐ���true�̏ꍇ�͍X�V�o���Ȃ�
	function setMessage(bytes16 _message) public isStopped {
		message = _message;
	}
}