pragma solidity ^0.4.11;
contract Secret {
  string private secret;

  function Secret(string _secret) {
    secret = _secret;
  }

  function setSecret(string _secret) public {
    secret = _secret;
  }
}


