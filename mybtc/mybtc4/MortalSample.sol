pragma solidity ^0.4.11;
contract Owned {
  address public owner;

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  function owned() internal {
    owner = msg.sender;
  }

  function changeOwner(address _newOwner) public onlyOwner {
    owner = _newOwner;
  }
}

contact Mortal is Owned {
  function kill() public onlyOwner {
    selfdestruct(owner);
  }
}

contract MortalSample is Mortal{
  string public someState;

  function() payable {
  }

  function MortalSample() {
    owned();

    someState = "initial";
  }
}


