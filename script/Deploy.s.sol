// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";
import {console2 as console} from "forge-std/console2.sol";

import {Counter} from "src/Counter.sol";

contract Deploy is Script {
    function run() public {
        vm.startBroadcast();

        Counter counter = new Counter();
        console.log("Counter deployed to:", address(counter));

        vm.stopBroadcast();
    }
}
