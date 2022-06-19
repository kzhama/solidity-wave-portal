// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;
    uint256 private seed;

    event NewWave(address indexed from, string message, uint256 timestamp);

    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }

    mapping(address => uint256) public lastWavedAt;

    Wave[] waves;

    constructor() payable {
        console.log("Constructed.. !!");
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {
        require(
            lastWavedAt[msg.sender] + 3 minutes < block.timestamp,
            "Wait more minutes to WAVE"
        );

        totalWaves += 1;
        console.log("%s has waved!", msg.sender);
        waves.push(Wave(msg.sender, _message, block.timestamp));

        lastWavedAt[msg.sender] = block.timestamp;

        emit NewWave(msg.sender, _message, block.timestamp);

        seed = (block.timestamp + block.difficulty + seed) % 100;
        if (seed <= 50) {
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Not enough balance in the contract to complete the transaction"
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have total %s waves", totalWaves);
        return totalWaves;
    }
}
