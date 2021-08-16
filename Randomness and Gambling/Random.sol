// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract Random {

  function unsafeBlockRandom() public view returns (uint) {
    return uint(blockhash(block.number - 1)) % 100;
  }
  
  uint private _baseIncrement;
  
  function unsafeIncrementRandom() public returns (uint) {
    return uint(keccak256(abi.encode(_baseIncrement++))) % 100;
  }
}
