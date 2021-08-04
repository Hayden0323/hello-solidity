// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

abstract contract ERC223ReceivingContract {
  function tokenFallback(address _from, uint _value, bytes calldata _data) virtual public;
}