// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {StakingPool} from "../src/stakingPool.sol";

contract StakingPoolScript is Script {
    StakingPool public stakingPool;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        stakingPool = new StakingPool(100000000000000000); 

        vm.stopBroadcast();
    }
}
