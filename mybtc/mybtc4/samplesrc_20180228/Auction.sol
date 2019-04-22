pragma solidity ^0.4.11;
contract Auction {
	address public highestBidder;	// �ō��z�񎦃A�h���X
	uint public highestBid;	// �ō��񎦊z
	
	/// �R���X�g���N�^
	function Auction() payable {
		highestBidder = msg.sender;
		highestBid = 0;
	}
	
	/// Bid�p�̊֐�
	function bid() public payable {
		// bid�����݂̍ō��z�����傫�����Ƃ��m�F����
		require(msg.value > highestBid);
		
		// �ԋ��z�ޔ�
		uint refundAmount = highestBid;
		
		// �ō��z�񎦃A�h���X�ޔ�
		address currentHighestBidder = highestBidder;
		
		// �X�e�[�g�X�V
		highestBid = msg.value;
		highestBidder = msg.sender;
		
		// �ō��z��񎦂��Ă���bidder�ɕԋ�����
		if(!currentHighestBidder.send(refundAmount)) {
			throw;
		}
	}
}