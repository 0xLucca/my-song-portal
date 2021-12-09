// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract SongPortal {
    uint256 totalSongs;
    mapping(address=>string) songs;

    constructor() {
        console.log("I am a contract and I am alive");
    }

    function shareSong() public {
        totalSongs += 1;
        console.log("%s has shared a song with u!", msg.sender);
    }

    function getTotalSongs() public view returns (uint256) {
        console.log("We have %d total songs!", totalSongs);
        return totalSongs;
    }
}