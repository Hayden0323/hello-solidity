// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

interface AlarmWakeUp {
  function callback(bytes calldata _data) external;
}

contract AlarmService {

  struct TimeEvent {
    address addr;
    bytes data;
  }

  mapping(uint => TimeEvent[]) private _events;

  function set (uint _time) public {
    TimeEvent memory _timeEvent;
    _timeEvent.addr = msg.sender;
    _timeEvent.data = msg.data;
    _events[_time].push(_timeEvent);
  }

  function call (uint _time)  public {
    TimeEvent[] memory timeEvents = _events[_time];
    for (uint i = 0; i < timeEvents.length; i++) {
      AlarmWakeUp(timeEvents[i].addr).callback(timeEvents[i].data);
    }
  }
}

contract AlarmTrigger is AlarmWakeUp {
    
  AlarmService private _alarmService;
    
  constructor () {
    _alarmService = new AlarmService();
  }
    
  function callback (bytes memory _data) override public {
    // Do something
  }
    
  function setAlarm () public {
    _alarmService.set(block.timestamp + 60);
  }   
}
