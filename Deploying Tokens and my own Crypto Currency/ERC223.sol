// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

interface ERC223 {
  function transfer(address _to, uint _value, bytes memory _data) external returns (bool);
  event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
}