// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {Test} from "forge-std/Test.sol";
import {IERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract Tests {
    function returnMsgSender() public view returns (address) {
        return msg.sender;
    }
}

contract GeneralTest is Test {
    address public test;
    Tests public tests;

    function setUp() public {
        test = address(0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045);
        tests = new Tests();
    }

    function testDeal() public {
        uint256 balance = test.balance;
        deal(test, balance + 10);
        assertEq(test.balance, balance + 10);
    }

    function testPrank() public {
        vm.deal(test, 1 << 128);
        vm.prank(test);
        address a = tests.returnMsgSender();
        assertEq(a, test);
    }

    function testPrankBlock() public {
        vm.deal(test, 1 << 128);
        vm.startPrank(test);
        address a = tests.returnMsgSender();
        assertEq(a, test);

        vm.stopPrank();
        a = tests.returnMsgSender();
        assertNotEq(a, test);
    }

    function testCoinbase() public {
        assertNotEq(block.coinbase, test);
        vm.coinbase(test);
        assertEq(block.coinbase, test);
    }

    function testMock1() public {
        vm.mockCall(
            address(0),
            abi.encodeWithSelector(IERC20.balanceOf.selector, address(1)),
            abi.encode(10)
        );
        assertEq(IERC20(address(0)).balanceOf(address(1)), 10);
    }

    function testMock2() public {
        vm.mockCall(
            address(0),
            abi.encodeWithSelector(IERC20.balanceOf.selector),
            abi.encode(10)
        );
        assertEq(IERC20(address(0)).balanceOf(address(1)), 10);
        assertEq(IERC20(address(0)).balanceOf(address(2)), 10);
    }
}