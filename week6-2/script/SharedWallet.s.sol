// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "../lib/forge-std/src/Script.sol";
import {SharedWallet} from "../src/SharedWallet.sol";

contract SharedWallet is Script {
    SharedWallet public sharedwallet;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
    
        sharedwallet = new SharedWallet();

        vm.stopBroadcast();
    }
}
