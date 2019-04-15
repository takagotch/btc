pragma solidity ^0.4.11;
contract CrowdFunding {
  struct Investor {
    address addr;
    uint amount;
  }

  address public owner;
  uint public numInvestors;
  uint public deadline;
  string public status;
  bool public ended;
  uint public goalAmount;
  uint public totalAmount;
  mapping (uint => Investor) public investors;

  modifier onlyOwner () {
    require(msg.sender == owner);
    _;
  }

  function CrowdFunding(uint _duration, uint _goalAmount) {
    owner = msg.sender;

    deadline = now + _duration;

    goalAmount = _goalAmount;
    status = "Funding";
    ended = false;

    numInvestors = 0;
    totalAmount = 0;
  }

  function fund() payable {
    require(!ended);

    Investor inv = investors[numInvestors++];
    inv.addr = msg.sender;
    inv.amount = msg.value;
    totalAmount += inv.amount;
  }

  function checkGoalReached () public onlyOwner {
    require(!ended);

    require(now >= deadline);

    if(totalAmount >= goalAmount) {
      status = "Campaign Succeeded";
      ended = true;
      if(!owner.send(this.balance)) {
        throw;
      }
    } else {
      uint i = 0;
      status = "Campaign Failed";
      ended = true;

      while(i <= numInvestors) {
        if(!investors[i].addr.send(investros[i].amount)) {
	  throw;
	}
	i++;
      }
    }
  }

  function kill() public onlyOwner {
    selfdestruct(owner);
  }
}




