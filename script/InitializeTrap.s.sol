// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {ERC20WhaleTrap} from "../src/ERC20WhaleTrap.sol";

contract InitializeTrap is Script {
    function run(address trapAddress) external {
        address mockErc20Address = 0x01fe773Ca03C058A67B7793bCd8506Bc47CAbFd0;
        address mockPriceFeedAddress = 0x5202Bf5fEe1f45786e944C0e6A92fc323D02066f;

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        ERC20WhaleTrap(trapAddress).initialize(mockErc20Address, mockPriceFeedAddress);

        vm.stopBroadcast();
    }
}
