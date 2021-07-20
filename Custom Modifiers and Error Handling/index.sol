// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

interface Regulator {
  function checkValue(uint amount) external returns (bool);
  function loan() external returns (bool);
}

contract Bank is Regulator {
  uint private value;
  address private owner;

  modifier ownerFunc {
    require(owner == msg.sender );
    _;
  }

  constructor(uint amount) {
    value = amount;
    owner = msg.sender;
  }

  function deposit (uint amount) public ownerFunc {
    value += amount;
  }

  function withdraw (uint amount) public ownerFunc {
    if (checkValue(amount)) {
      value -= amount;
    }
  }

  function balance () public view returns (uint) {
    return value;
  }

  function checkValue(uint amount) public view override returns (bool) {
    return value >= amount;
  }

  function loan () public view override returns (bool) {
    return value > 0;
  }
}

contract Basic is Bank(10) {
  string private name;
  uint private age;

  function setName(string memory newName) public {
    name = newName;
  }

  function getName() public view returns (string memory) {
    return name;
  }

  function setAge (uint newAge) public {
    age = newAge;
  }

  function getAge () public view returns (uint) {
    return age;
  }
}

contract TestThrows {
  function testAssert () public pure {
    assert(1 == 2);
  }

  function testRequire() public pure {
    require(2 == 1);
  }

  function testRevert() public pure {
    revert();
  }
}