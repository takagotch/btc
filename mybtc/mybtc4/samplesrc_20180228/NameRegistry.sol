pragma solidity ^0.4.11;
contract NameRegistry {

	// �R���g���N�g�p�̍\����
	struct Contract {
		address owner;
		address addr;
		bytes32 description;
	}

	// �o�^�ς݂̃��R�[�h��
	uint public numContracts;

	// �R���g���N�g��ێ�����}�b�v
	mapping (bytes32  => Contract) public contracts;
    
	/// �R���X�g���N�^
	function NameRegistry() {
		numContracts = 0;
	}

	/// �R���g���N�g��o�^����
	function register(bytes32 _name) public returns (bool){
		// ���O�����p����Ă��Ȃ���Γo�^����
		if (contracts[_name].owner == 0) {
			Contract con = contracts[_name];
			con.owner = msg.sender;
			numContracts++;
			return true;
		} else {
			return false;
		}
	}

	/// �R���g���N�g���폜����
	function unregister(bytes32 _name) public returns (bool) {
		if (contracts[_name].owner == msg.sender) {
			contracts[_name].owner = 0;
 			numContracts--;
 			return true;
		} else {
			return false;
		}
	}
	
	/// �R���g���N�g�̃I�[�i�[��ύX����
	function changeOwner(bytes32 _name, address _newOwner) public onlyOwner(_name) {
		contracts[_name].owner = _newOwner;
	}
	
	/// �R���g���N�g�̃I�[�i�[���擾����
	function getOwner(bytes32 _name) constant public returns (address) {
		return contracts[_name].owner;
	}
    
	/// �R���g���N�g�̃A�h���X���Z�b�g����
	function setAddr(bytes32 _name, address _addr) public onlyOwner(_name) {
		contracts[_name].addr = _addr;
    }
    
	/// �R���g���N�g�̃A�h���X���擾����
	function getAddr(bytes32 _name) constant public returns (address) {
		return contracts[_name].addr;
	}
        
	/// �R���g���N�g�̐�����ݒ肷��
	function setDescription(bytes32 _name, bytes32 _description) public onlyOwner(_name) {
		contracts[_name].description = _description;
	}

	/// �R���g���N�g�̐������擾����
	function getDescription(bytes32 _name) constant public returns (bytes32)  {
		return contracts[_name].description;
	}
    
	/// �֐��ďo���O�ɌĂяo����鏈���ł���modifier���`
	modifier onlyOwner(bytes32 _name) {
	    require(contracts[_name].owner == msg.sender);
		_;
	}
}
