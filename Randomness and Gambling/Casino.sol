// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract Casino {
    
  uint private start;
    
  uint private buyPeriod = 1000;
  uint private verifyPeriod = 100;
  uint private checkPeriod = 100;
    
  mapping(address => uint) private _tickets;
  mapping(address => uint) private _winnings;

  address[] _entries;
  address[] _verified;

  uint private winnerSeed;
  bool private hasWinner;
  address private winner;
    
  constructor() {
    start = block.timestamp;    
  }
    
  /**
   * This should NOT be part of the contract!!
   */
  function unsafeEntry(uint number, uint salt) public payable returns (bool) {
    return buyTicket(generateHash(number, salt));
  }
    
  function generateHash(uint number, uint salt) public pure returns (uint) {
    return uint(keccak256(abi.encode(number + salt)));
  }
    
  function buyTicket(uint hash) public payable returns (bool) {
    // Within the timeframe
    require(block.timestamp < start + buyPeriod);
    // Correct amount
    require(1 ether == msg.value);
    // 1 entry per address
    require(_tickets[msg.sender] == 0);
    _tickets[msg.sender] = hash;
    _entries.push(msg.sender);
    return true;
  }
    
  function verifyTicket(uint number, uint salt) public returns (bool) {
    // Within the timeframe
    require(block.timestamp >= start + buyPeriod);
    require(block.timestamp < start + buyPeriod + verifyPeriod);
    // Has a valid entry
    require(_tickets[msg.sender] > 0);
    // Validate hash
    require(salt > number);
    require(generateHash(number, salt) == _tickets[msg.sender]);
    winnerSeed = winnerSeed ^ salt ^ uint(block.number);
    _verified.push(msg.sender);
    return true;
  }
    
  function checkWinner() public returns (bool) {
    // Within the timeframe
    require(block.timestamp >= start + buyPeriod + verifyPeriod);
    require(block.timestamp < start + buyPeriod + verifyPeriod + checkPeriod);
    if (!hasWinner) {
      winner = _verified[winnerSeed % _verified.length];
      _winnings[winner] = _verified.length - 10 ether;
      hasWinner = true;
    }
    return msg.sender == winner;
  }
    
  function claim(address payable to) public {
    // Has winnings to claim
    require(to == msg.sender);
    require(_winnings[msg.sender] > 0);
    uint claimAmount = _winnings[msg.sender];
    _winnings[msg.sender] = 0;
    to.transfer(claimAmount);        
  }
}