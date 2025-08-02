// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract MockPriceFeed is AggregatorV3Interface {
    int256 private currentPrice = 2000e8;
    uint80 private roundId;
    uint256 private updatedAt;
    uint256 private startedAt;
    uint80 private answeredInRound;
    uint256 private nonce;

    event PriceUpdated(int256 newPrice);

    function updatePrice() public {
        nonce++;
        uint256 rand = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, nonce))) % 200;
        int256 delta = int256(rand) - 100;
        delta *= 1e8;

        currentPrice = currentPrice + delta;
        roundId++;
        updatedAt = block.timestamp;
        startedAt = block.timestamp;
        answeredInRound = roundId;

        emit PriceUpdated(currentPrice);
    }

    function latestRoundData()
        external
        view
        override
        returns (
            uint80,
            int256,
            uint256,
            uint256,
            uint80
        )
    {
        return (roundId, currentPrice, startedAt, updatedAt, answeredInRound);
    }

    function decimals() external pure override returns (uint8) {
        return 8;
    }

    function description() external pure override returns (string memory) {
        return "Mock Price Feed";
    }

    function version() external pure override returns (uint256) {
        return 1;
    }

    function getRoundData(uint80)
        external
        view
        override
        returns (
            uint80,
            int256,
            uint256,
            uint256,
            uint80
        )
    {
        return (roundId, currentPrice, startedAt, updatedAt, answeredInRound);
    }

    // Optional getter for debugging
    function getCurrentPrice() external view returns (int256) {
        return currentPrice;
    }
}
