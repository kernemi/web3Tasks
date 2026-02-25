// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {SimpleSaving} from "../src/simplesaving.sol";

contract SimpleSavingScript is Script {
    SimpleSaving public simpleSaving;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        simpleSaving = new SimpleSaving();

        vm.stopBroadcast();
    }
}
