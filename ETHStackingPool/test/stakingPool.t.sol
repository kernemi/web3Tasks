// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/stakingPool.sol";

contract StakingPoolTest is Test {

    StakingPool pool;

    address user1;
    address user2;

    uint256 rewardRate = 1 ether; // 1 ETH per second (easy for testing)

    // Allow contract to receive ETH
    receive() external payable {}

    function setUp() public {
        pool = new StakingPool(rewardRate);

        user1 = address(0x1);
        user2 = address(0x2);

        vm.deal(user1, 10 ether);
        vm.deal(user2, 10 ether);

        // fund contract so it can pay rewards
        vm.deal(address(pool), 100 ether);
    }

  
    function testStake() public {
        vm.prank(user1);
        pool.stake{value: 1 ether}();

        (uint256 amount, uint256 startTime, bool claimed) = pool.stakes(user1);

        assertEq(amount, 1 ether);
        assertEq(claimed, false);
        assertGt(startTime, 0);
    }

    function testStakeRevertIfZero() public {
        vm.prank(user1);
        vm.expectRevert("Must stake more than 0");
        pool.stake{value: 0}();
    }

  
    function testCalculateReward() public {
        vm.prank(user1);
        pool.stake{value: 1 ether}();

        // move time forward
        vm.warp(block.timestamp + 10);

        uint256 reward = pool.calculateReward(user1);

        assertEq(reward, 10 ether); // 10 sec * 1 ether
    }

    function testRewardZeroIfClaimed() public {
        vm.prank(user1);
        pool.stake{value: 1 ether}();

        vm.warp(block.timestamp + 5);

        vm.prank(user1);
        pool.unstake();

        uint256 reward = pool.calculateReward(user1);

        assertEq(reward, 0);
    }

    function testUnstake() public {
        vm.prank(user1);
        pool.stake{value: 1 ether}();

        vm.warp(block.timestamp + 10);

        uint256 balanceBefore = user1.balance;

        vm.prank(user1);
        pool.unstake();

        uint256 balanceAfter = user1.balance;

        // 1 ether stake + 10 ether reward
        assertEq(balanceAfter, balanceBefore + 11 ether);

        (, , bool claimed) = pool.stakes(user1);
        assertEq(claimed, true);
    }

    function testUnstakeRevertIfAlreadyClaimed() public {
        vm.prank(user1);
        pool.stake{value: 1 ether}();

        vm.prank(user1);
        pool.unstake();

        vm.prank(user1);
        vm.expectRevert("Stake already claimed");
        pool.unstake();
    }

    function testMultipleUsers() public {
        vm.prank(user1);
        pool.stake{value: 1 ether}();

        vm.prank(user2);
        pool.stake{value: 2 ether}();

        vm.warp(block.timestamp + 5);

        uint256 reward1 = pool.calculateReward(user1);
        uint256 reward2 = pool.calculateReward(user2);

        assertEq(reward1, 5 ether);
        assertEq(reward2, 5 ether);
    }
}