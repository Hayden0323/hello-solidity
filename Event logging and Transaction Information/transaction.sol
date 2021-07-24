// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract Transaction {

  event SenderLogger(address);
  event ValueLogger(uint);

  address private owner;

  modifier isOwner {
    require(owner == msg.sender);
    _;
  }

  modifier validValue {
    assert(msg.value >= 1 ether);
    _;
  }

  constructor() {
    owner = msg.sender;
  }

  function send () public payable isOwner validValue {
    emit SenderLogger(msg.sender);
    emit ValueLogger(msg.value);
  }
}