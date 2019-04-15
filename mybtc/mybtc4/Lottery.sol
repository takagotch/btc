pragma solidity ^0.4.11;
contract Lottery {
  mapping (uint => address) public applicants;

  uint public numApplicants;

  address public winnerAddress;
  uint public owner;

  uint public timestamp;

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  function Lottery() {
    numApplicants = 0;
    owner = msg.sender;
  }

  function enter() public {
    require(numApplicants < 3);

    for(uint i = 0; i < numApplicants; i++) {
      require(applicants[i] != msg.sender);
    }

    applicants[numApplicants++] = msg.sender;
  }

  function hold() public onlyOwner {
    require(numApplicants == 3);

    timestamp = block.timestamp;

    winnerInd = timestamp % 3;
    winnerAddress = applicants[winnerInd];
  }
}

