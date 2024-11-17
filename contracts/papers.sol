// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.25;

contract BuyPaperContract {
    address public seller;
    uint256 public cost;
    string public paperId;
    address public buyer;

    constructor(string memory _paperId, uint256 _cost) {
        seller = msg.sender;
        paperId = _paperId;
        cost = _cost;
    }

    function buyPaper() public payable {
        require(buyer == address(0), "Paper is already bought");
        require(msg.value == cost, "You need to pay more");

        address payable _to = payable(seller);
        _to.transfer(cost);
        buyer = msg.sender;
    }
}

contract SwapPaperContract {
    address public seller;
    string public paperId;
    address public offering;
    string public swapTo;
    bool public accepted;

    constructor(string memory _paperId) {
        seller = msg.sender;
        paperId = _paperId;
    }

    modifier replyToOffer() {
        require(msg.sender == seller, "Only seller can do it");
        require(offering != address(0), "There is no offer yet");
        require(!accepted, "Swap is already done");
        _;
    }

    function offer(string memory _swapTo) public {
        require(!accepted, "Swap is already done");
        require(offering == address(0), "Swap is already offered");
        offering = msg.sender;
        swapTo = _swapTo;
    }

    function accept() public replyToOffer {
        accepted = true;
    }

    function decline() public replyToOffer {
        offering = address(0);
        paperId = "";
    }
}
