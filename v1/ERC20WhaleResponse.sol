// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @notice This response contract is triggered by the ERC20WhaleTrap
/// It logs the event data when a large whale movement or price spike is detected.
contract ERC20WhaleResponse {
    /// @notice Emitted when a trap is triggered
    /// @param tracked The address being watched
    /// @param oldBalance Token balance from previous block sample
    /// @param newBalance Token balance from current block sample
    /// @param oldPrice Price feed value from previous sample
    /// @param newPrice Price feed value from current sample
    event WhaleEventTriggered(
        address indexed tracked,
        uint256 oldBalance,
        uint256 newBalance,
        int256 oldPrice,
        int256 newPrice
    );

    /// @notice Function triggered by Drosera when a trap fires
    /// @dev Match this signature in `drosera.toml` under `response_function`
    function respondWithERC20Context(
        address tracked,
        uint256 oldBalance,
        uint256 newBalance,
        int256 oldPrice,
        int256 newPrice
    ) external {
        emit WhaleEventTriggered(tracked, oldBalance, newBalance, oldPrice, newPrice);
    }
}
