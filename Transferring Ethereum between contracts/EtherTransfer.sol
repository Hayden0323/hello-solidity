// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract EtherTransferTo {
  fallback () external payable {}

  function getBalance () public view returns (uint) {
    return address(this).balance;
  }
}

contract EtherTransferFrom {

  EtherTransferTo private _instance;

  constructor () {
    _instance = new EtherTransferTo();
  }

  function getBalance () public view returns (uint) {
    return address(this).balance;
  }

  function getBalanceOfInstance () public view returns (uint) {
    return _instance.getBalance();
  }

  fallback () external payable {
    payable(address(_instance)).transfer(msg.value);
  }
}