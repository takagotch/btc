pragma solidity ^0.4.11;
contract MarketPlaceOverflow {
	address public owner;
	uint8 public stockQuantity;	// �݌ɐ�
	
	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	
	/// �ǉ��݌ɐ���\������C�x���g
	event AddStock(uint _addedQuantity);
			
	/// �R���X�g���N�^
	function MarketPlaceOverflow() {
		owner = msg.sender;
		stockQuantity = 100;
	}
	
	/// �݌ɂ̒ǉ�����
	function addStock(uint8 _addedQuantity) public onlyOwner {
		AddStock(_addedQuantity);
		stockQuantity += _addedQuantity;
	}
}