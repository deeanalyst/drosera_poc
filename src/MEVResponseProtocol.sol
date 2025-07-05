// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract MEVResponseProtocol {
    event SandwichDetected(
        uint256 blockNumber,
        address indexed victim,
        address indexed attacker,
        address tokenIn,
        address tokenOut,
        uint256 amountIn,
        uint256 amountOut,
        bytes32 txHash1,
        bytes32 txHash2,
        bytes32 txHash3
    );

    function logSandwich(
        uint256 blockNumber,
        address victim,
        address attacker,
        address tokenIn,
        address tokenOut,
        uint256 amountIn,
        uint256 amountOut,
        bytes32 txHash1,
        bytes32 txHash2,
        bytes32 txHash3
    ) external {
        emit SandwichDetected(blockNumber, victim, attacker, tokenIn, tokenOut, amountIn, amountOut, txHash1, txHash2, txHash3);
    }
}
