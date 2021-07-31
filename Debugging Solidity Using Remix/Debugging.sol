// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract Debugging {
  
  uint[] private vars;

  function assignment () public pure {
    uint myValue1 = 1;
    uint myValue2 = 2;
    assert(myValue1 == myValue2);
  }

  function memoryAlloc () public pure {
    string memory myString = 'test';
    assert(bytes(myString).length == 10);
  }

  function storageAlloc () public {
    vars.push(2);
    vars.push(3);
    assert(vars.length == 4);
  }
}