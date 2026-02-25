// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleSaving {

    mapping(address => uint256) private balances;

    // Events
    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    // Allow contract to receive ETH directly
    receive() external payable {
        require(msg.value > 0, "Deposit must be greater than zero");
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    // Deposit function
    function deposit() external payable {
        require(msg.value > 0, "Deposit must be greater than zero");
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    // Withdraw function
    function withdraw(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");

        emit Withdrawn(msg.sender, amount);
    }

    // Check user balance
    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    // Check total contract balance (now public)
    function getATMBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
