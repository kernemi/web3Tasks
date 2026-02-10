// SPDX-License-Identifier: MIT

// pragma solidity ^0.8.17;

pragma solidity ^0.8.0;

contract StudentSavingsWallet {
    address public owner;
    uint256 public minimumDeposit;
    uint256 public lockDuration; // in seconds

    mapping(address => uint256) private balances;
    mapping(address => uint256) private lastDepositTime;

    struct Transaction {
        address user;
        uint256 amount;
        string txType; // "DEPOSIT" or "WITHDRAW"
        uint256 timestamp;
    }
    Transaction[] public transactions;

    // Events
    event Deposit(address indexed user, uint256 amount, uint256 timestamp);
    event Withdraw(address indexed user, uint256 amount, uint256 timestamp);

    // Modifiers
    modifier onlyOwner() {
    require(msg.sender == owner, "Only owner can perform this action");
    _;
    }

    constructor(uint256 _minimumDeposit, uint256 _lockDuration) {
    owner = msg.sender;
    minimumDeposit = _minimumDeposit;
    lockDuration = _lockDuration;
    }


    function deposit() external payable 
    {   
        require(msg.value >= minimumDeposit, "Deposit amount must be at least minimumDeposit");
        balances[msg.sender] += msg.value;
        // Emit Deposit event
        transactions.push(Transaction({
            user: msg.sender,
            amount: msg.value,
            txType: "DEPOSIT",
            timestamp: block.timestamp
        }));

        emit Deposit(msg.sender, msg.value, block.timestamp);
    }


    function withdraw(uint256 amount) external
    {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        require(
            block.timestamp >= lastDepositTime[msg.sender] + lockDuration,
            "Funds are time-locked"
        );
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);

        transactions.push(Transaction({
            user: msg.sender,
            amount: amount,
            txType: "WITHDRAW",
            timestamp: block.timestamp
        }));

        emit Withdraw(msg.sender, amount, block.timestamp);
    }
    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    function getTransactions() external view returns (Transaction[] memory) {
        return transactions;
    }

    // Admin functions
    function updateMinimumDeposit(uint256 newAmount) external onlyOwner {
        minimumDeposit = newAmount;
    }


    function updateLockDuration(uint256 newDuration) external onlyOwner {
        lockDuration = newDuration;
    }
}