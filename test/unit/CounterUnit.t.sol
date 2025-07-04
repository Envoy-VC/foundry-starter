// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";

import {Counter} from "src/Counter.sol";
import {SetUp} from "test/common/SetUp.sol";

contract CounterUnitTest is Test, SetUp {
    function setUp() public override {
        super.setUp();
    }

    function testIncrement() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    function testSetNumber() public {
        counter.setNumber(10);
        assertEq(counter.number(), 10);
    }
}
