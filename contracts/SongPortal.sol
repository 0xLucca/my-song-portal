// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract SongPortal {
    uint256 totalSongs;
    uint256 private seed;

    event NewSong(address indexed from, uint256 timestamp, string message);

    struct Song {
        address sender;
        string message;
        uint256 timestamp;
    }

    Song[] Songs;

    /*
     * This is an address => uint mapping, meaning I can associate an address with a number!
     * In this case, I'll be storing the address with the last time the user shared a song with us.
     */
    mapping(address => uint256) public lastSharedAt;

    constructor() payable {
        console.log("We have been constructed!");
        /*
         * Set the initial seed
         */
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function shareSong(string memory _message) public {
        /*
         * We need to make sure the current timestamp is at least 30 segs bigger than the last timestamp we stored
         */
        require(
            lastSharedAt[msg.sender] + 30 seconds < block.timestamp,
            "Wait 30s"
        );

        /*
         * Update the current timestamp we have for the user
         */
        lastSharedAt[msg.sender] = block.timestamp;

        totalSongs += 1;
        console.log("%s has shared a song with us!", msg.sender);

        Songs.push(Song(msg.sender, _message, block.timestamp));

        /*
         * Generate a new seed for the next user that sends a song
         */
        seed = (block.difficulty + block.timestamp + seed) % 100;

        if (seed <= 50) {
            console.log("%s won!", msg.sender);

            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than they contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        emit NewSong(msg.sender, block.timestamp, _message);
    }

    function getAllSongs() public view returns (Song[] memory) {
        return Songs;
    }

    function getTotalSongs() public view returns (uint256) {
        return totalSongs;
    }
}