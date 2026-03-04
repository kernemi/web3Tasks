// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    mapping (address => uint256) private counters;

    event CounterIncremented(address indexed user, uint256 newcount);
    event CounterReset(address indexed user);

    function increment() public {
        counters[msg.sender]++;
        emit CounterIncremented(msg.sender, counters[msg.sender]);
    }

    function reset() public {
        require(counters[msg.sender] > 0, "counter is already zero");
        counters[msg.sender] = 0;
        emit CounterReset(msg.sender);
    }

    function getCounter(address user) external view returns (uint256) {
        return counters[user];
    }
}
