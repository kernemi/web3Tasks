// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "../lib/forge-std/src/Test.sol";
import {simpleVault} from "../src/simpleVault.sol";

contract simpleValutTest is Test {
    simpleVault vault;

    address user = address(1);

    function setUp() public {
        vault = new simpleVault();
        vm.deal(user, 10 ether);
    }

    function testDeposit() public {
        vm.prank(user);
        vault.deposit{value: 2 ether}();
        assertEq(vault.balances(user), 2 ether);
    }

    function testwithdraw() public {
        vm.prank(user);
        vault.deposit{value: 2 ether}();
        assertEq(vault.balances(user), 2 ether);

        vm.prank(user);
        vault.withdraw();
        assertEq(vault.balances(user), 0);
    }

    function testwithdrawFail() public {
        vm.prank(user);
        vm.expectRevert("Not enough balance");
        vault.withdraw();
    }
}
