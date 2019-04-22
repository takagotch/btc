pragma solidity ^0.4.11;
contract MarketPlaceOverflowMod3 {
	address public owner;
	uint8 public stockQuantity;	// �݌ɐ�
	
	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	
	/// �ǉ��݌ɐ���\������C�x���g
	event AddStock(uint _addedQuantity);
			
	/// �R���X�g���N�^
	function MarketPlaceOverflowMod3() {
		owner = msg.sender;
		stockQuantity = 100;
	}
	
	/// �݌ɂ̒ǉ�����
	function addStock(uint _addedQuantity) public onlyOwner {
		// �ǉ����̃`�F�b�N
		require(_addedQuantity < 256);
		
		// �I�[�o�[�t���[�`�F�b�N
		require(stockQuantity + uint8(_addedQuantity) > stockQuantity);
		
		AddStock(_addedQuantity);
		stockQuantity += uint8(_addedQuantity);
	}
}