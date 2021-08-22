// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract MultiSigWallet {
  address private _owner;
  mapping(address => uint8) private _owners;

  modifier isOwner {
    require(msg.sender == _owner);
    _;
  }

  modifier validOwner {
    require(msg.sender == _owner || _owners[msg.sender] == 1);
    _;
  }

  event Deposit(address from, uint256 amount);
  event Withdraw(address to, uint256 amount);
  event Transfer(address from, address to, uint256 amount);

  constructor {
    _owner = msg.sender;
  }

  function addOwner (address owner) external isOwner {
    _owners[owner] = 1;
  }

  function removeOwner (address owner) external isOwner {
    _owners[owner] = 0;
  }

  receive () external payable {
    emit Deposit(msg.sender, msg.value);
  }

  function withdraw (uint256 amount) external validOwner {
    require(address(this).balance >= amount);
    msg.sender.transfer(amount);
    emit Withdraw(msg.sender, amount);
  }

  function transferTo(address to, uint256 amount) external validOwner {
    require(address(this).balance >= amount);
    to.transfer(amount);
    emit Transfer(msg.sender, to, amount);
  }
}