// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SharedWallet.sol";

contract SharedWalletTest is Test {

    SharedWallet wallet;

    address owner;
    address user1;
    address user2;

    receive() external payable {}

    function setUp() public {
        owner = address(this); 
        user1 = address(0x1);
        user2 = address(0x2);

        wallet = new SharedWallet();

        // Give ETH to users
        vm.deal(user1, 10 ether);
        vm.deal(user2, 10 ether);
    }

    function testDeposit() public {
        vm.prank(user1);
        wallet.deposit{value: 1 ether}();

        assertEq(wallet.balances(user1), 1 ether);
        assertEq(wallet.totalBalance(), 1 ether);
    }

    function testMultipleDeposits() public {
        vm.prank(user1);
        wallet.deposit{value: 1 ether}();

        vm.prank(user2);
        wallet.deposit{value: 2 ether}();

        assertEq(wallet.balances(user1), 1 ether);
        assertEq(wallet.balances(user2), 2 ether);
        assertEq(wallet.totalBalance(), 3 ether);
    }


    function testWithdrawByOwner() public {
        vm.prank(user1);
        wallet.deposit{value: 2 ether}();

        uint256 ownerBalanceBefore = owner.balance;

        wallet.withdraw(1 ether);

        uint256 ownerBalanceAfter = owner.balance;

        assertEq(ownerBalanceAfter, ownerBalanceBefore + 1 ether);
        assertEq(wallet.totalBalance(), 1 ether);
    }

    function testWithdrawNotOwnerReverts() public {
        vm.prank(user1);
        wallet.deposit{value: 1 ether}();

        vm.prank(user1);
        vm.expectRevert("only owner can withdraw");
        wallet.withdraw(1 ether);
    }

    function testWithdrawTooMuchReverts() public {
        vm.prank(user1);
        wallet.deposit{value: 1 ether}();

        vm.expectRevert("not enough balance");
        wallet.withdraw(2 ether);
    }

    function testDepositStored() public {
        vm.prank(user1);
        wallet.deposit{value: 1 ether}();

        (address user, uint256 amount, uint256 time) = wallet.deposits(0);

        assertEq(user, user1);
        assertEq(amount, 1 ether);
        assertGt(time, 0);
    }
}