// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "../lib/forge-std/src/Script.sol";
import {OwnerMessageBoard} from "../src/ownerMessageBoard.sol";


contract OwnerMessageBoardScript is Script {
    OwnerMessageBoard public board;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        board = new OwnerMessageBoard("Hello, World!");

        vm.stopBroadcast();
    }
}