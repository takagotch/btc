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

contract AccessRestriction is Owned{
  string public someState;

  function AccessRestriction() {
    owned();

    someState = "initial";
  }

  function updateSomeState(string_newState) public onlyOwner {
    someState = _newState;
  }
}

