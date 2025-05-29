// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Reputrust {
    address public owner;

    struct Loan {
        address borrower;
        uint256 amount;
        uint256 deadline;
        bool repaid;
    }

    uint256 public loanId;
    mapping(uint256 => Loan) public loans;
    mapping(address => uint256) public reputation;

    event LoanRequested(uint256 loanId, address borrower, uint256 amount, uint256 deadline);
    event LoanRepaid(uint256 loanId, address borrower);
    event ReputationIncreased(address user, uint256 score);

    constructor() {
        owner = msg.sender;
    }

    function requestLoan(uint256 amount, uint256 duration) external {
        require(reputation[msg.sender] >= 50, "Low reputation");
        loanId++;
        loans[loanId] = Loan({
            borrower: msg.sender,
            amount: amount,
            deadline: block.timestamp + duration,
            repaid: false
        });

        payable(msg.sender).transfer(amount);
        emit LoanRequested(loanId, msg.sender, amount, block.timestamp + duration);
    }

    function repayLoan(uint256 _loanId) external payable {
        Loan storage loan = loans[_loanId];
        require(msg.sender == loan.borrower, "Not borrower");
        require(!loan.repaid, "Already repaid");
        require(msg.value == loan.amount, "Incorrect amount");

        loan.repaid = true;
        reputation[msg.sender] += 10;

        emit LoanRepaid(_loanId, msg.sender);
        emit ReputationIncreased(msg.sender, reputation[msg.sender]);
    }

    function fundPool() external payable {}

    function getReputation(address user) external view returns (uint256) {
        return reputation[user];
    }

    function setReputation(address user, uint256 score) external {
        require(msg.sender == owner, "Only owner");
        reputation[user] = score;
    }

    function contractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
