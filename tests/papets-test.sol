// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.25;

import "remix_tests.sol";
import "../contracts/PaperContract.sol";

contract BuyPaperContractTest {
    BuyPaperContract public buyPaperContract;

    address seller;
    string paperId = "12345";
    uint256 cost = 1 ether;

    function beforeAll() public {
        buyPaperContract = new BuyPaperContract(paperId, cost);
        seller = address(this);
    }

    function testConstructor() public {
        Assert.equal(buyPaperContract.seller(), seller, "Seller should be the deployer");
        Assert.equal(buyPaperContract.paperId(), paperId, "Paper ID should match");
        Assert.equal(buyPaperContract.cost(), cost, "Cost should match");
        Assert.equal(buyPaperContract.buyer(), address(0), "Buyer should be initially unset");
    }

    function testInsufficientFunds() public {
        (bool success, ) = address(buyPaperContract).call{value: cost / 2}(
            abi.encodeWithSignature("buyPaper()")
        );
        Assert.ok(!success, "Transaction should fail due to insufficient funds");
    }

    function testAlreadyBought() public {
        (bool success, ) = address(buyPaperContract).call{value: cost}(
            abi.encodeWithSignature("buyPaper()")
        );
        Assert.ok(!success, "Transaction should fail because the paper is already bought");
    }

    receive() external payable {}
}