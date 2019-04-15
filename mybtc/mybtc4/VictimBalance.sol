pragma solidity ^0.4.11;
contract VictimBalance {
  mapping (address => uint) public userBalances;

  event MessageLog(string);

  event BalanceLog(uint);

  function VictimBalance() {
  }

  function addToBalance() public payable {
    userBalance[msg.sender] += msg.value;
  }

  function withdrawBalance() public payable returns(bool) {
    MessageLog("withdrawBalance started.");
    BalanceLog(this.balance);

    if(userBalance[msg.sender] == 0) {
      MessageLog("No Balance.");
      return false;
    }

    if (!(msg.sender.call.value(userBalances[msg.sender])())) { throw; }

    userBalances[msg.sender] = 0;

    Message("withdrawBalance finished.");

    return true;
  }
}


