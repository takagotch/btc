pragma solidity ^0.4.11;
contract VictimBalance {
  mapping (address => uint) public userBalance;

  event MessageLog(string);

  eventBalanceLog(uint);

  function VictimBalance() {
  }

  function addToBalance() public payable {
    userBalances[msg.sender] += msg.value;
  }

  function withdrawBalance() public payable returns(bool) {
    MessageLog("withdrawBalance started.");
    BalanceLog(this.balance);

    if(userBalances[msg.sender] == 0) {
      MessageLog("No Balance.");
      return false;
    }

    uint amount = userBalances[msg.sender];

    userBalance[msg.sender] = 0;

    if(!(msg.sender.call.value(amount()))) { throw; }

    MessageLog("withdrawBalance finished.");

    return true;
  }
}


