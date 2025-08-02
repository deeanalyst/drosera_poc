// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {MockERC20} from "../src/MockERC20.sol";

contract SendTokens is Script {
    function run() external {
        address mockErc20Address = 0x01fe773Ca03C058A67B7793bCd8506Bc47CAbFd0;
        address trackedAddress = 0x6aaEE634A4Aff5960fA9a8970E0145E35Ef9E039;
        uint256 amount = 1000 * 1e18;

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        MockERC20(mockErc20Address).mint(trackedAddress, amount);

        vm.stopBroadcast();
    }
}
