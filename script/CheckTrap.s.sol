// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {ERC20WhaleTrap} from "../src/ERC20WhaleTrap.sol";

contract CheckTrap is Script {
    function run(address trapAddress) external view {
        ERC20WhaleTrap trap = ERC20WhaleTrap(trapAddress);
        console.log("Token Address:", address(trap.token()));
        console.log("Price Feed Address:", address(trap.priceFeed()));
    }
}
