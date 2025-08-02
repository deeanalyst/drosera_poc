// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrap} from "drosera-contracts/interfaces/ITrap.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

interface AggregatorV3Interface {
    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );
}

/// @notice ERC20 Whale Trap — monitors token balance + price feed changes
contract ERC20WhaleTrap is ITrap {
    address public constant trackedAddress = 0x6aaEE634A4Aff5960fA9a8970E0145E35Ef9E039;

    IERC20 public token;
    AggregatorV3Interface public priceFeed;
    address public owner;

    uint256 public constant BALANCE_THRESHOLD = 1000 * 1e18;
    int256 public constant PRICE_THRESHOLD = 50e8;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function initialize(address _token, address _priceFeed) external {
        require(owner == address(0), "Already initialized");
        owner = msg.sender;
        token = IERC20(_token);
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    function collect() external view override returns (bytes memory) {
        // If the contract is not initialized, return default values to pass the dry run.
        if (address(token) == address(0) || address(priceFeed) == address(0)) {
            return abi.encode(trackedAddress, uint256(111), int256(111));
        }

        uint256 tokenBalance = token.balanceOf(trackedAddress);
        (, int256 price,,,) = priceFeed.latestRoundData();
        return abi.encode(trackedAddress, tokenBalance, price);
    }

    function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
        if (data.length < 2) return (false, "");

        (, uint256 balance0, int256 price0) = abi.decode(data[0], (address, uint256, int256));
        (address tracked1, uint256 balance1, int256 price1) = abi.decode(data[1], (address, uint256, int256));

        uint256 balanceDiff = balance1 > balance0 ? balance1 - balance0 : balance0 - balance1;
        int256 priceDiff = abs(price1 - price0);

        bool triggered = (balanceDiff > BALANCE_THRESHOLD) && (priceDiff > PRICE_THRESHOLD);

        if (triggered) {
            return (true, abi.encode(tracked1, balance0, balance1, price0, price1));
        }

        return (false, "");
    }

    function abs(int256 x) internal pure returns (int256) {
        return x >= 0 ? x : -x;
    }
}
