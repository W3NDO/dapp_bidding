// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Auction} from "../src/Auction.sol";

contract AuctionTest is Test {
    Auction public auction;
    receive() external payable {} // required for the payout tests

    function setUp() public {
        auction = new Auction(1 days, payable(address(this)), 1234567890);
    }

    function test_Bid() public {
        auction.bid{value: 1 ether}();
        auction.bid{value: 1.1 ether}();

        assertEq(auction.highestBidder(), address(this));
        assertEq(auction.highestBid(), 1.1 ether);
    }

    function test_Withdraw() public {
        auction = new Auction(1 days, payable(address(this)), 1234567890);
        address bidder = makeAddr("bidder");
        uint256 bidAmount = 0.2 ether;

        vm.deal(bidder, 10 ether);
        vm.deal(address(auction), 9 ether);

        uint256 initialWalletBalance = bidder.balance;

        vm.prank(bidder);
        auction.bid{value: 1 ether}();
        bool success = auction.withdraw();

        assertTrue(success);
        assertEq(bidder.balance, 9 ether); // takes bidders money
        assertEq(address(auction).balance, 10 ether); // contract now has 1 more ether
    }

    function test_AuctionNotEnded() public {
        vm.expectRevert(Auction.AuctionNotYetEnded.selector);
        auction.auctionEnd();
    }

    function test_AuctionAlreadyEnded() public {
        uint256 biddingTime = 1 days;

        auction = new Auction(1 days, payable(address(this)), 1234567890);

        // advance time past auction closing
        vm.warp(block.timestamp + biddingTime + 1);

        vm.expectRevert(Auction.AuctionAlreadyEnded.selector);

        auction.bid{value: 1 ether}();
    }

    function test_BidNotHighEnough() public {
        address bidder1 = address(1);
        address bidder2 = address(2);

        vm.deal(bidder1, 10 ether);
        vm.deal(bidder2, 10 ether);

        // First bid (also current highest bid)
        vm.prank(bidder1);
        auction.bid{value: 1.2 ether}();

        // Expect revert on second bid
        vm.prank(bidder2);
        vm.expectRevert(
            abi.encodeWithSelector(
                Auction.BidNotHighEnough.selector,
                1.2 ether // current highestBid
            )
        );

        auction.bid{value: 1.2 ether}();
    }

    function test_AuctionEndAlreadyCalled() public {
        address bidder1 = address(1);
        address bidder2 = address(2);

        vm.deal(bidder1, 10 ether);
        vm.deal(bidder2, 10 ether);

        vm.prank(bidder1);
        auction.bid{value: 1.2 ether}();
        vm.prank(bidder2);
        auction.bid{value: 1.21 ether}();
        vm.warp(block.timestamp + 1 days + 1);

        auction.auctionEnd();

        vm.expectRevert(Auction.AuctionEndAlreadyCalled.selector);
        auction.auctionEnd();
    }
}
