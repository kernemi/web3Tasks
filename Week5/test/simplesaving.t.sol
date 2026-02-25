// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {SimpleSaving} from "../src/simplesaving.sol";

contract SimpleSavingTest is Test {
    SimpleSaving public simpleSaving;

    receive() external payable {} 

    function setUp() public {
        simpleSaving = new SimpleSaving();
    }

    function test_Deposit() public {
        uint256 initialBalance = simpleSaving.getBalance();
        simpleSaving.deposit{value: 0.001 ether}();
        assertEq(simpleSaving.getBalance(), initialBalance + 0.001 ether);
    }

    function test_Withdraw() public {
        simpleSaving.deposit{value: 0.001 ether}();
        uint256 initialBalance = simpleSaving.getBalance();
        simpleSaving.withdraw(0.0005 ether);
        assertEq(simpleSaving.getBalance(), initialBalance - 0.0005 ether);
    }
}
