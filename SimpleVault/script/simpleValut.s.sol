// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from"../lib/forge-std/src/Script.sol";
import {simpleVault} from "../src/simpleVault.sol";

contract simpleValutScript is Script {
    simpleVault public counter;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        counter = new simpleVault();

        vm.stopBroadcast();
    }
}
