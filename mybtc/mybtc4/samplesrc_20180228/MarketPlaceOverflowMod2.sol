pragma solidity ^0.4.11;
contract MarketPlaceOverflowMod2 {
	address public owner;
	uint8 public stockQuantity;	// �݌ɐ�
	
	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	
	/// �ǉ��݌ɐ���\������C�x���g
	event AddStock(uint8 _addedQuantity);
			
	/// �R���X�g���N�^
	function MarketPlaceOverflowMod2() {
		owner = msg.sender;
		stockQuantity = 100;
	}
	
	/// �݌ɂ̒ǉ�����
	function addStock(uint8 _addedQuantity) public onlyOwner {
		// �ǉ����̃`�F�b�N
		require(_addedQuantity < 256);
		
		// �I�[�o�[�t���[�`�F�b�N
		require(stockQuantity + _addedQuantity > stockQuantity);
		
		AddStock(_addedQuantity);
		stockQuantity += _addedQuantity;
	}
}