pragma solidity ^0.4.11;
contract NameRegistry {
  struct Contract {
    address owner;
    address addr;
    bytes32 description;
  }

  uint public numContracts;

  mapping (bytes32 => Contract) public contracts;

  function NameRegistry() {
    numContracts = 0;
  }

  function register(bytes32 _name) public returns (bool) {
    if(contracts[_name].owner == 0) {
      Contract con = contracts[_name];
      con.owner = msg.sender;
      numContracts++;
      return true;
    } else {
      return false;
    }
  }

  function unregister(byte32 _name) public returns (bool) {
    if (contracts[_name].owner == msg.sender) {
      contracts[_name].owner = 0;
      numContracts--;
      return true;
    } else {
      return false;
    }
  }

  function changeOwner(byte32 _name, address _newOwner) public onlyOwner(_name) {
    contracts[_name].owner = _newOwner;
  }

  function getOwner(byte32 _name) contant public returns (address) {
    return contracts[_name].owner;
  }

  function setAddr(bytes32 _name, address _addr) public onlyOwner(_name) {
    contracts[_name].addr = _addr;
  }

  function getAddr(byte32 _name) constant public returns (address) {
    return contracts[_name].addr; 
  }

  function setDescription(bytes _name, bytes32 _description) public onlyOwner(_name) {
    contracts[_name].description = _description;
  }

  function getDescription(bytes32 _name) constant public returns (bytes32) {
    return contracts[_name].description;
  }

  modifier onlyOwner(bytes32 _name) {
    require(contracts[_name].owner == msg.sender);
    _;
  }
}

