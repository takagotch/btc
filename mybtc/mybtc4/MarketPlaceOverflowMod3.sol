pragma solidity ^0.4.11;
contract MarketPlaceOverflowMod3 {
  address public owner;
  uint8 public stockQuantity;

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  event AddStock(uint _addedQuantity);

  function MarketPlaceOverflowMod3() {
    owner = msg.sender;
    stockQuantity = 100;
  }

  function addStock(uint _addedQuantity) public onlyOwner {
    require(_addedQuantity < 256);

    require(stockQuantity + uint8(_addedQuantity) > stockQuantity);

    AddStock(_addedQuantity);
    stockQuantity += uint8(_addedQuantity);
  }
}


