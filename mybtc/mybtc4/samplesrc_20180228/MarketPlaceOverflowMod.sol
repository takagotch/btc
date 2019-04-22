pragma solidity ^0.4.11;
contract MarketPlaceOverflowMod {
	address public owner;
	uint8 public stockQuantity;	// �݌ɐ�
	
	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	
	/// �ǉ��݌ɐ���\������C�x���g
	event AddStock(uint8 _addedQuantity);
			
	/// �R���X�g���N�^
	function MarketPlaceOverflowMod() {
		owner = msg.sender;
		stockQuantity = 100;
	}
	
	/// �݌ɂ̒ǉ�����
	function addStock(uint8 _addedQuantity) public onlyOwner {
		// �I�[�o�[�t���[�`�F�b�N
		require(stockQuantity + _addedQuantity > stockQuantity);
		
		AddStock(_addedQuantity);
		stockQuantity += _addedQuantity;
	}
}