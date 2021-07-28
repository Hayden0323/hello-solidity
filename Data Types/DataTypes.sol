// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract DataTypes {

  bool myBool = false;

  int8 myInt8 = -128;
  uint8 myUInt = 255;

  string myString;
  uint8[] myStringArr;

  bytes1 MyBytes1;
  bytes32 MyBytes32;

  enum Action {ADD, REMOVE, UPDATE}

  Action myAction = Action.ADD;

  address myAddress;

  function asignAddress () public {
    myAddress = msg.sender;
    myAddress.balance;
  }

  uint[] myIntArr = [1,2,3];

  function arrFunc() public {
    myIntArr.push(1);
    myIntArr.length;
    myIntArr[0];
  }

  uint[10] myFixedArr;
    
  struct Account {
    uint balance;
    uint dailyLimit;
  }

  Account myAccount;

  mapping (address => Account) _accounts;

  function setBalance () public payable {
    _accounts[msg.sender].balance += msg.value;
  }

  function getBalance() public view returns (uint) {
    return _accounts[msg.sender].balance;
  }
}