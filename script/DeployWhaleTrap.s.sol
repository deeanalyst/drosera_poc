// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {MockERC20} from "../src/MockERC20.sol";
import {MockPriceFeed} from "../src/MockPriceFeed.sol";
import {ERC20WhaleResponse} from "../src/ERC20WhaleResponse.sol";

contract DeployWhaleTrap is Script {
    function run()
        external
        returns (
            address mockErc20,
            address mockPriceFeed,
            address responseContract
        )
    {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        mockErc20 = address(new MockERC20());
        console.log("MockERC20 deployed at:", mockErc20);

        mockPriceFeed = address(new MockPriceFeed());
        console.log("MockPriceFeed deployed at:", mockPriceFeed);

        responseContract = address(new ERC20WhaleResponse());
        console.log("ERC20WhaleResponse deployed at:", responseContract);

        vm.stopBroadcast();
    }
}
