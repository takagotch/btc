pragma solidity ^0.4.11;
contract SmartSwitch {
  struct Switch {
    address addr;
    uint endTime;
    bool status;
  }

  address public owner;
  address public iot;

  mapping (uint => Switch) public switches;
  uint public numPaid;

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  modifier onlyIot() {
    require(msg.sender == iot);
    _;
  }

  function SmartSwitch(address _iot) {
    owner = msg.sender;
    iot = _iot;
    numPaid = 0;
  }

  function PayToSwitch() public payable {
    require(msg.value == 1000000000000);

    Switch s = switches[numPaid++];
    s.addr = msg.sender;
    s.endTime = now + 300;
    s.status = true;
  }

  function updateStatus(uint _index) public onlyIot {
    require(switches[_index].addr != 0);

    require(now > switches[_index].endTime);

    switches[_index].status = false;
  }

  function withdrawFunds() public onlyOwner {
    if(!owner.send(this.balance))
      throw;
  }

  function kill() public onlyOwner {
    selfdestruct(owner);
  }
}


