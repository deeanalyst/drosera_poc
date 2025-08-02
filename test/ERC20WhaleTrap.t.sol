// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {ERC20WhaleTrap} from "../src/ERC20WhaleTrap.sol";
import {MockERC20} from "../src/MockERC20.sol";
import {MockPriceFeed} from "../src/MockPriceFeed.sol";

contract ERC20WhaleTrapTest is Test {
    ERC20WhaleTrap public whaleTrap;
    MockERC20 public mockToken;
    MockPriceFeed public mockPriceFeed;

    address internal constant TRACKED_ADDRESS = 0x6aaEE634A4Aff5960fA9a8970E0145E35Ef9E039;

    function setUp() public {
        whaleTrap = new ERC20WhaleTrap();
        mockToken = new MockERC20();
        mockPriceFeed = new MockPriceFeed();

        // Initialize the trap
        whaleTrap.initialize(address(mockToken), address(mockPriceFeed));
    }

    function test_Collect() public view {
        bytes memory data = whaleTrap.collect();
        (address tracked, uint256 balance, int256 price) = abi.decode(data, (address, uint256, int256));

        assertEq(tracked, TRACKED_ADDRESS);
        assertEq(balance, 0); // Initially, the tracked address has no tokens
        assertTrue(price > 0);
    }

    function test_ShouldRespond_False_InsufficientData() public view {
        bytes[] memory data = new bytes[](1);
        data[0] = whaleTrap.collect();

        (bool should, ) = whaleTrap.shouldRespond(data);
        assertFalse(should);
    }

    function test_ShouldRespond_True_ThresholdsExceeded() public {
        // State 1: Initial state
        bytes memory data0 = whaleTrap.collect();

        // State 2: Simulate significant balance and price change
        uint256 largeBalance = 2000 * 1e18;
        mockToken.mint(TRACKED_ADDRESS, largeBalance);
        mockPriceFeed.updatePrice(); // This will change the price

        bytes memory data1 = whaleTrap.collect();

        // Check response
        bytes[] memory data = new bytes[](2);
        data[0] = data0;
        data[1] = data1;

        (bool should, bytes memory response) = whaleTrap.shouldRespond(data);

        assertTrue(should, "Should respond when thresholds are met");
        (address tracked, uint256 oldBalance, uint256 newBalance, int256 oldPrice, int256 newPrice) =
            abi.decode(response, (address, uint256, uint256, int256, int256));

        assertEq(tracked, TRACKED_ADDRESS);
        assertEq(oldBalance, 0);
        assertEq(newBalance, largeBalance);
        assertTrue(newPrice != oldPrice);

        assertEq(tracked, TRACKED_ADDRESS);
        assertEq(oldBalance, 0);
        assertEq(newBalance, largeBalance);
        assertTrue(newPrice != oldPrice);
    }
}
