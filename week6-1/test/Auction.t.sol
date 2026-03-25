// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {SimpleAuction} from "../src/Auction.sol";


contract AuctionTest is Test {
    SimpleAuction auctionContract;

    address seller = address(0x1);
    address bidder1 = address(0x2);
    address bidder2 = address(0x3);

    function setUp() public {
        auctionContract = new SimpleAuction();
    }

    function testCreateAuction() public {
        vm.prank(seller);
        auctionContract.createAuction(100);

        assertEq(auctionContract.auctionCount(), 1);

        (address _seller, address highestBidder, uint256 highestBid, uint256 endTime, bool ended) =
            auctionContract.auctions(1);

        assertEq(_seller, seller);
        assertEq(highestBidder, address(0));
        assertEq(highestBid, 0);
        assertFalse(ended);
        assertTrue(endTime > block.timestamp);
    }

    function testBid() public {
        vm.prank(seller);
        auctionContract.createAuction(100);

        vm.deal(bidder1, 1 ether);
        vm.prank(bidder1);
        auctionContract.bid{value: 0.5 ether}(1);

        (, address highestBidder, uint256 highestBid,,) =
            auctionContract.auctions(1);

        assertEq(highestBidder, bidder1);
        assertEq(highestBid, 0.5 ether);

        vm.deal(bidder2, 1 ether);
        vm.prank(bidder2);
        auctionContract.bid{value: 0.7 ether}(1);

        (, highestBidder, highestBid,,) =
            auctionContract.auctions(1);

        assertEq(highestBidder, bidder2);
        assertEq(highestBid, 0.7 ether);

        assertEq(auctionContract.pendingReturns(bidder1), 0.5 ether);
    }

    function testWithdraw() public {
        vm.prank(seller);
        auctionContract.createAuction(100);

        vm.deal(bidder1, 1 ether);
        vm.prank(bidder1);
        auctionContract.bid{value: 0.5 ether}(1);

        vm.deal(bidder2, 1 ether);
        vm.prank(bidder2);
        auctionContract.bid{value: 0.7 ether}(1);

        uint256 beforeBalance = bidder1.balance;

        vm.prank(bidder1);
        auctionContract.withdraw();

        assertEq(auctionContract.pendingReturns(bidder1), 0);
        assertEq(bidder1.balance, beforeBalance + 0.5 ether);
    }

    function testEndAuction() public {
        vm.prank(seller);
        auctionContract.createAuction(1);

        vm.deal(bidder1, 1 ether);
        vm.prank(bidder1);
        auctionContract.bid{value: 0.5 ether}(1);

        vm.warp(block.timestamp + 2);

        uint256 beforeBalance = seller.balance;

        vm.prank(seller);
        auctionContract.endAuction(1);

        (, , , , bool ended) = auctionContract.auctions(1);
        assertTrue(ended);

        assertEq(seller.balance, beforeBalance + 0.5 ether);
    }
}