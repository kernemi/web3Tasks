// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "../lib/forge-std/src/Script.sol";
import {SimpleAuction} from "../src/Auction.sol";

contract AuctionScript is Script {
    SimpleAuction public auction;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
    
        auction = new SimpleAuction();

        vm.stopBroadcast();
    }
}
