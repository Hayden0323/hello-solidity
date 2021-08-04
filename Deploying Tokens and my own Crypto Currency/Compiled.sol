// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

interface ERC20 {
  function transferFrom(address _from, address _to, uint _value) external returns (bool);
  function approve(address _spender, uint _value) external returns (bool);
  function allowance(address _owner, address _spender) external returns (uint);
  event Approval(address indexed _owner, address indexed _spender, uint _value);
}

interface ERC223 {
  function transfer(address _to, uint _value, bytes memory _data) external returns (bool);
  event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
}

abstract contract ERC223ReceivingContract {
  function tokenFallback(address _from, uint _value, bytes calldata _data) virtual public;
}

abstract contract Token {
  string internal _symbol;
  string internal _name;
  uint8 internal _decimals;
  uint internal _totalSupply = 1000;
  mapping (address => uint) internal _balanceOf;
  mapping (address => mapping (address => uint)) internal _allowances;
  
  constructor(string memory __symbol, string memory __name, uint8 __decimals, uint __totalSupply) {
    _symbol = __symbol;
    _name = __name;
    _decimals = __decimals;
    _totalSupply = __totalSupply;
  }
    
  function name() public view returns (string memory) {
    return _name;
  }
    
  function symbol() public view returns (string memory) {
    return _symbol;
  }
  
  function decimals() public view returns (uint8) {
    return _decimals;
  }
  
  function totalSupply() public virtual view returns (uint) {
    return _totalSupply;
  }
  
  function balanceOf(address _addr) public virtual returns (uint);
  function transfer(address _to, uint _value) public virtual returns (bool);
  event Transfer(address indexed _from, address indexed _to, uint _value);
}

library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

contract MyFirstToken is Token("MFT", "My First Token", 18, 1000), ERC20, ERC223 {

  using SafeMath for uint;

  constructor() {
    _balanceOf[msg.sender] = _totalSupply;
  }
  
  function totalSupply() public override view returns (uint) {
    return _totalSupply;
  }
  
  function balanceOf(address _addr) public override view returns (uint) {
    return _balanceOf[_addr];
  }

  function transfer(address _to, uint _value) public override returns (bool) {
    if (_value > 0 && 
        _value <= _balanceOf[msg.sender] &&
        !isContract(_to)
    ) {
      _balanceOf[msg.sender] =_balanceOf[msg.sender].sub(_value);
      _balanceOf[_to] = _balanceOf[_to].add(_value);
      emit Transfer(msg.sender, _to, _value);
      return true;
    }
    return false;
  }

  function transfer(address _to, uint _value, bytes calldata _data) public override returns (bool) {
    if (_value > 0 && 
        _value <= _balanceOf[msg.sender] &&
        isContract(_to)
    ) {
      _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);
      _balanceOf[_to] = _balanceOf[_to].add(_value);
      ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
      _contract.tokenFallback(msg.sender, _value, _data);
      emit Transfer(msg.sender, _to, _value, _data);
      return true;
    }
    return false;
  }

  function isContract(address _addr) public view returns (bool) {
    uint codeSize;
    assembly {
      codeSize := extcodesize(_addr)
    }
    return codeSize > 0;
  }

  function transferFrom(address _from, address _to, uint _value) public override returns (bool) {
    if (_allowances[_from][msg.sender] > 0 &&
        _value > 0 &&
        _allowances[_from][msg.sender] >= _value &&
        _balanceOf[_from] >= _value
    ) {
      _balanceOf[_from] = _balanceOf[_from].sub(_value);
      _balanceOf[_to] = _balanceOf[_to].add(_value);
      _allowances[_from][msg.sender] = _allowances[_from][msg.sender].sub(_value);
      emit Transfer(_from, _to, _value);
      return true;
    }
    return false;
  }
  
  function approve(address _spender, uint _value) public override returns (bool) {
    _allowances[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }
  
  function allowance(address _owner, address _spender) public view override returns (uint) {
    return _allowances[_owner][_spender];
  }
}