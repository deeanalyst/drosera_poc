// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Script.sol";
import "../src/MEVResponseProtocol.sol";

contract DeployResponseProtocol is Script {
    function run() external {
        vm.startBroadcast();
        new MEVResponseProtocol();
        vm.stopBroadcast();
    }
}
