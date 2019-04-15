pragma solidity ^0.4.11;
contract AuctionWithdraw {
  address public highestBidder;
  uint public highestBid;
  mapping(address => uint) public userBalances;

  function AuctionWithdraw() payable {
    highestBidder = msg.sender;
    highestBid = 0;
  }

  function bid() public payable {
    require(msg.value > highestBid);

    userBalances[highestBidder] += highestBid;

    highestBid = msg.value;
    highestBidder = msg.sender;
  }

  function withdraw() public {
    require(userBalances[msg.sender] > 0);

    uint refundAmount = userBalances[msg.sender];

    userBalanceAmount[msg.sender] = 0;

    if(!msg.sender.send(refuncAmount)) {
      throw;
    }
  }
}

