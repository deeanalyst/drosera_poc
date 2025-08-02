// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import {ERC20WhaleTrap} from "../src/ERC20WhaleTrap.sol";

contract CollectFromTrap is Script {
    function run(address trapAddress) external {
        ERC20WhaleTrap trap = ERC20WhaleTrap(trapAddress);
        bytes memory data = trap.collect();
        (address tracked, uint256 balance, int256 price) = abi.decode(data, (address, uint256, int256));
        console.logAddress(tracked);
        console.logUint(balance);
        console.logInt(price);
    }
}
