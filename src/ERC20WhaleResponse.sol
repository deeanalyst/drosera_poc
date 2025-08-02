// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ERC20WhaleResponse {
    event WhaleEventTriggered(
        address indexed tracked,
        uint256 oldBalance,
        uint256 newBalance,
        int256 oldPrice,
        int256 newPrice
    );

    function whaleResponse(
        address tracked,
        uint256 oldBalance,
        uint256 newBalance,
        int256 oldPrice,
        int256 newPrice
    ) external {
        emit WhaleEventTriggered(tracked, oldBalance, newBalance, oldPrice, newPrice);
    }
}
