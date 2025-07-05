// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import {ITrap} from "drosera-contracts/interfaces/ITrap.sol";

interface IUniswapV2Pair {
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112, uint112, uint32);
}

struct SandwichData {
    address victim;
    address attacker;
    address tokenIn;
    address tokenOut;
    uint256 amountIn;
    uint256 amountOut;
    bytes32[3] sandwichTxHashes;
}

contract MEVTrap is ITrap {
    // Ganti dengan alamat MEVResponseProtocol yang sudah kamu deploy
    address private responseProtocol = 0xAD8e31Da04D1dE260854B97f9f49d7945e4e9032;

    constructor() {}

    function collect() external view returns (bytes memory) {
        // Simulasi data deteksi sandwich untuk demonstrasi.
        return abi.encode(SandwichData({
            victim: address(0x123),
            attacker: address(0x456),
            tokenIn: 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,   // WETH
            tokenOut: 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,  // USDC
            amountIn: 1 ether,
            amountOut: 0.4 ether,
            sandwichTxHashes: [
                bytes32(0xabc0000000000000000000000000000000000000000000000000000000000000),
                bytes32(0xdef0000000000000000000000000000000000000000000000000000000000000),
                bytes32(0xfeed000000000000000000000000000000000000000000000000000000000000)
            ]
        }));
    }

    function shouldRespond(bytes[] calldata data) external pure returns (bool, bytes memory) {
        if (data.length == 0) return (false, "");

        SandwichData memory s = abi.decode(data[0], (SandwichData));
        if (s.amountOut > 0 && s.victim != address(0)) {
            return (
                true,
                abi.encode(
                    s.victim,
                    s.attacker,
                    s.tokenIn,
                    s.tokenOut,
                    s.amountIn,
                    s.amountOut,
                    s.sandwichTxHashes
                )
            );
        }
        return (false, "");
    }
}
