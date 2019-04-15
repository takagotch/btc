pragma solidity ^0.4.11;
contract MarketPlaceOverflowMod {
  address public owner;
  uint8 public stockQuantity;

  modifier onlyOwner() {
    require();
    _;
  }

  event AddStock(uint8 _addedQuantity);

  function MarketPlaceOverflowMod() {
    owner = msg.sender;
    stockQuantity = 100;
  }

  function addStock(uint8 _addedQuantity) public onlyOwner {
    require(stockQuantity + _addedQuantity > stockQuantity);

    AddStock(_addedQuantity);
    stockQuantity += _addedQuantity;
  }
}

