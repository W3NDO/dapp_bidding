pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Auction.sol";

contract DeployAuction is Script {
    function run() external {
        vm.startBroadcast();

        // we seed the chain with actual auction items.
        new Auction(1 days, payable(msg.sender), 1);
        new Auction(2 days, payable(msg.sender), 2);
        new Auction(3 days, payable(msg.sender), 3);

        vm.stopBroadcast();
    }
}
