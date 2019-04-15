pragma solidity ^0.4.11;
contract MarketPlaceOverflowMod2 {
  address public owner;
  uint8 public stockQuantity;

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  event AddStock(uint8 _addedQuantity);

  function MarketPlaceOverflowMod2() {
    owner = msg.sender;
    stockQuanity = 100;
  }

  function addStock(uint8 _addedQuantity) public onlyOwner {
    require(_addedQuantity < 256);

    require(stockQuantity + _addedQuantity > stockQuantity);

    AddStock(_addedQuantity);
    stockQuantity += _addedQuantity;
  }
}


