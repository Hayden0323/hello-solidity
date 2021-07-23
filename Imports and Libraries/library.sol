// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

library IntExtended {
  function increment (uint _base) public pure returns (uint) {
    return _base + 1;
  }

  function decrement (uint _base) public pure returns (uint) {
    return _base - 1;
  }

  function incrementByValue(uint _base, uint _value) public pure returns (uint) {
    return _base + _value;
  }

   function decrementByValue(uint _base, uint _value) public pure returns (uint) {
    return _base - _value;
  }
}