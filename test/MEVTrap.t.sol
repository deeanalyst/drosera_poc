// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import {Test} from "forge-std/Test.sol";
import {MEVTrap, SandwichData} from "../src/MEVTrap.sol";

contract MEVTrapTest is Test {
    uint8 numBlocks = 3; // kecilkan agar aman
    uint256 blockNumber;
    uint256[] forkIds = new uint256[](numBlocks);
    string rpc = "https://ethereum-hoodi-rpc.publicnode.com";

    function setUp() public {
        uint256 latestIndex = numBlocks - 1;
        uint256 latestForkId = vm.createSelectFork(rpc);
        blockNumber = block.number;

        // Hindari underflow
        if (blockNumber < numBlocks) {
            blockNumber = numBlocks + 10;
        }

        forkIds[latestIndex] = latestForkId;

        for (uint8 i = 0; i < latestIndex; i++) {
            uint256 forkBlock = blockNumber - i - 1;
            forkIds[i] = vm.createFork(rpc, forkBlock);
        }
    }

    function test_collect_and_shouldRespond() public {
        bytes[] memory dataPoints = new bytes[](numBlocks);

        // Kumpulkan data dari masing-masing block
        for (uint8 i = 0; i < numBlocks; i++) {
            vm.selectFork(forkIds[i]);
            dataPoints[i] = new MEVTrap().collect();
        }

        (bool shouldRespond, bytes memory payload) = new MEVTrap().shouldRespond(dataPoints);

        assertTrue(shouldRespond);
        // Decode untuk logging
        (
            address victim,
            address attacker,
            address tokenIn,
            address tokenOut,
            uint256 amountIn,
            uint256 amountOut,
            bytes32[3] memory sandwichTxHashes
        ) = abi.decode(payload, (address, address, address, address, uint256, uint256, bytes32[3]));

        emit log_named_address("Victim", victim);
        emit log_named_address("Attacker", attacker);
        emit log_named_uint("Amount In", amountIn);
        emit log_named_uint("Amount Out", amountOut);
        emit log_bytes32(sandwichTxHashes[0]);
    }
}
