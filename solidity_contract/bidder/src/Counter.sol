// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    uint public count;

    constructor() {
        count = 0;
    }

    function setNumber(uint num) public{
        count = num;
    }

    function increment() public {
        count += 1;
    }

    function decrement() public{
        require(count > 0, "counter can't go below 0");
        count -= 1;
    }
}
