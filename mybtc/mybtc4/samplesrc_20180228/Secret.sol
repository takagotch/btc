pragma solidity ^0.4.11;
contract Secret {
	string private secret;	// �閧�̕�����
	
	/// �R���X�g���N�^
	function Secret(string _secret) {
		secret = _secret;
	}
	
	/// �閧�̕������ݒ�
	function setSecret(string _secret) public {
		secret = _secret;
	}
}