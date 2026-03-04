// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "../lib/forge-std/src/Test.sol";
import {OwnerMessageBoard} from "../src/ownerMessageBoard.sol";

contract OwnerMessageBoardTest is Test {
    OwnerMessageBoard board;

    address owner = address(this);
    address user = address(1);

    function setUp() public {
        board = new OwnerMessageBoard("Hello");
    }

    function testOwnerCanUpdate() public {
        board.updateMessage("New Message");
        assertEq(board.message(), "New Message");
    }

    function testNonOwnerCannotUpdate() public {
        vm.prank(user);
        vm.expectRevert("Not owner");
        board.updateMessage("Hack");
    }

    function testEventEmitted() public {
        vm.expectEmit(true, false, false, true);
        emit OwnerMessageBoard.MessageUpdated("Updated");

        board.updateMessage("Updated");
    }
}
