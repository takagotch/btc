pragma solidity ^0.4.11;
contract HelloEthereum {
:	// �R�����g��@
	string public msg1;	
	
	string private msg2; // �R�����g��A
	
	/* �R�����g��B */
	address public owner;
	
	uint8 public counter;
	
	/// �R���X�g���N�^
	function HelloEthereum(string _msg1) {
		// msg1�� _msg1��ݒ�
		msg1 = _msg1;
		
		// owner�ɖ{�R���g���N�g�𐶐������A�h���X��ݒ肷��
		owner = msg.sender;
		
		// counter�ɏ����l�Ƃ���0��ݒ�
		counter = 0;
	}
	
	/// msg2��setter
	function setMsg2(string _msg2) public {
		// if���̗�
		if(owner != msg.sender) {
			throw;
		} else {
			msg2 = _msg2;	
		}
	}
	
	// msg2��getter
	function getMsg2() constant public returns(string) {
		return msg2;
	}
	
	function setCounter() public {
		// for���̗�
		for(uint8 i = 0; i < 3; i++) {
			counter++;
		}
	}
}