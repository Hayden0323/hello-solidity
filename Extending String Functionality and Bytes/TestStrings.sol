// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "./Strings.sol";

contract TestStrings {
    
    using Strings for string;
    
    function testConcat(string memory _base) public pure returns (string memory result) {
      return _base.concat('_suffix');
    }
    
    function needleInHaystack(string memory _base) public pure returns (int) {
      return _base.strpos('t');
    }
}
