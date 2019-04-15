pragma solidity ^0.4.11;
contract MarketPlaceOverflow {
  address public owner;
  uint8 public stockQuantity;

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  event AddStock(uint _addedQuantity);

  function MarketPlaceOverflow() {
    owner = msg.sender;
    stockQuantity = 100;
  }

  function addStock(uint8 _addedQuantity) public onlyOwner {
    AddStock(_addedQuantity);
    stockQuantity += _addedQuantity;
  }
}

