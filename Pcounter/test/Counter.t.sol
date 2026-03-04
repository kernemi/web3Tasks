// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "../lib/forge-std/src/Test.sol";

import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter counter;

    address user1 = address(1);
    address user2 = address(2);

    function setUp() public {
        counter = new Counter();
    }

    function testIncrement() public {
        vm.prank(user1);
        counter.increment();
        assertEq(counter.getCounter(user1), 1);
        vm.prank(user1);
        counter.increment();
        assertEq(counter.getCounter(user1), 2);

        vm.prank(user2);
        counter.increment();
        assertEq(counter.getCounter(user2), 1);
    }

    function testReset() public {
        vm.prank(user1);
        counter.increment();
        vm.prank(user1);
        counter.increment();

        vm.prank(user1);
        counter.reset();
        assertEq(counter.getCounter(user1), 0);
    }
}