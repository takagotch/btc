pragma solidity ^0.4.11;
contract MarketPlaceOverflowMod4 {
	address public owner;
	uint public stockQuantity;	// �݌ɐ�
	
	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	
	/// �ǉ��݌ɐ���\������C�x���g
	event AddStock(uint _addedQuantity);
			
	/// �R���X�g���N�^
	function MarketPlaceOverflowMod4() {
		owner = msg.sender;
		stockQuantity = 0;
	}
	
	/// �݌ɂ̒ǉ�����
	function addStock(uint _addedQuantity) public onlyOwner {
		// �I�[�o�[�t���[�`�F�b�N
		require(stockQuantity + _addedQuantity > stockQuantity);
		
		AddStock(_addedQuantity);
		stockQuantity += _addedQuantity;
	}
}