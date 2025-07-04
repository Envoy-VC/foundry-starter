// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";

import {Counter} from "src/Counter.sol";

contract SetUp is Test {
    struct Accounts {
        Vm.Wallet richard;
        Vm.Wallet dinesh;
        Vm.Wallet gilfoyle;
        Vm.Wallet jared;
        Vm.Wallet erlich;
    }

    Counter public counter;

    Accounts public accounts;

    function setUp() public virtual {
        _setUpTestAccounts();
        counter = new Counter();
    }

    function _setUpTestAccounts() internal {
        // Create Accounts
        accounts = Accounts({
            richard: vm.createWallet("richard"),
            dinesh: vm.createWallet("dinesh"),
            gilfoyle: vm.createWallet("gilfoyle"),
            jared: vm.createWallet("jared"),
            erlich: vm.createWallet("erlich")
        });

        // Fund Accounts
        vm.deal(accounts.richard.addr, 100 ether);
        vm.deal(accounts.dinesh.addr, 100 ether);
        vm.deal(accounts.gilfoyle.addr, 100 ether);
        vm.deal(accounts.jared.addr, 100 ether);
        vm.deal(accounts.erlich.addr, 100 ether);
    }
}
