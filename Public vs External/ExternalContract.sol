// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract ExternalContract {
  function externalCall() external pure returns (uint) {
    return 123;
  }
  
  function publicCall() public pure returns (uint) {
    return 123;
  }
}