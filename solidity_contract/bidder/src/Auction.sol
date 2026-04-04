// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
// Inspired by the auction example in the solidity docs( https://docs.soliditylang.org/en/v0.8.35-pre.1/solidity-by-example.html )
// This inspiration is because of the time constraints. I decided to focus on the interaction between elixir and solidity.
contract Auction{

    address payable public beneficiary;
    uint public auctionEndTime;
    uint256 public auctionItemId;
    

    // current state of the auction
    address public highestBidder;
    uint public highestBid;
    bool public itemClaimed;

    // Allowed withdrawals of previous bids
    mapping(address => uint) pendingReturns;

    // Set to true at the end, disallows any changes
    bool ended;

    // events emitted on changes
    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    // ERRORS

    /// Error already ended
    error AuctionAlreadyEnded();

    /// There is already an equal or higher bid
    error BidNotHighEnough(uint highestBid);

    /// The auction has not ended yet
    error AuctionNotYetEnded();

    /// auctionEnd has already been called.
    error AuctionEndAlreadyCalled();

    constructor(
        uint biddingTime,
        address payable beneficiaryAddress,
        uint256 auctionItemId
    ){
        beneficiary = beneficiaryAddress;
        auctionEndTime = block.timestamp + biddingTime;
        auctionItemId = auctionItemId;
        itemClaimed = false;
        ended = false;
    }

    function bid() external payable {
        if(block.timestamp > auctionEndTime)
            revert AuctionAlreadyEnded();

        if (msg.value <= highestBid )
            revert BidNotHighEnough(highestBid);

        if (highestBid != 0){
            pendingReturns[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
        emit HighestBidIncreased(msg.sender, msg.value);
    } 

    function withdraw() external returns (bool){
        uint amount = pendingReturns[msg.sender];
        if (amount > 0 ){
            // Set this to zero because the recipient can call this function again as part of the receiving call
            // before `call` returns.
            pendingReturns[msg.sender] = 0;

            // payable here is type casting
            // (bool success, ) is some conceptual pattern matching. 
            (bool success, ) = payable(msg.sender).call{value: amount}("");
            if(!success) {
                // reset the amount owing
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }

    function auctionEnd() external {
        // It is a good guideline to structure functions that interact
        // with other contracts (i.e. they call functions or send Ether)
        // into three phases:
        // 1. checking conditions
        // 2. performing actions (potentially changing conditions)
        // 3. interacting with other contracts
        // If these phases are mixed up, the other contract could call
        // back into the current contract and modify the state or cause
        // effects (ether payout) to be performed multiple times.
        // If functions called internally include interaction with external
        // contracts, they also have to be considered interaction with
        // external contracts

        // 1. Checking conditions
        if ( ended ){
            revert AuctionEndAlreadyCalled();
        }
        if ( block.timestamp < auctionEndTime ){
            revert AuctionNotYetEnded();
        }

        // 2. Effect
        ended = true;
        itemClaimed = true;
        emit AuctionEnded(highestBidder, highestBid);

        // 3. Interaction
        (bool success, ) = beneficiary.call{value: highestBid}("");
        // (bool success, ) = _transferItem(msg.sender, auctionItemId);
        require( success );

    }

}