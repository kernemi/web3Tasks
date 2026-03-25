// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SharedWallet {

    /* =============================================================
                            STEP 1
       Create a Deposit struct.
       It must store:
       - user (address)
       - amount (uint256)
       - time (uint256)
    ============================================================= */

    // TODO: Define struct
    struct Deposit {
        address user;
        uint256 amount;
        uint256 time;
    }
    /* =============================================================
                            STEP 2
       Create state variables:
       - owner
       - totalBalance
       - mapping to track user balances
       - array to store deposits
    ============================================================= */

    // TODO: Declare owner
    address public owner;
    
    // TODO: Declare totalBalance
    uint256 public totalBalance;

    // TODO: Declare balances mapping
    mapping(address => uint256) public balances;

    // TODO: Declare deposits array
    Deposit[] public deposits;
    /* =============================================================
                            STEP 3
       Create constructor
       It should set owner = msg.sender
    ============================================================= */

    // TODO: Implement constructor
    constructor() {
        owner = msg.sender;
    }

    /* =============================================================
                            STEP 4
       Create deposit() function
       It should:
       - Be payable
       - Increase user balance
       - Increase totalBalance
       - Save deposit in array
    ============================================================= */

    // TODO: Implement deposit()
    function deposit() public payable{
        balances[msg.sender] += msg.value;
        totalBalance += msg.value;
        deposits.push(Deposit(msg.sender, msg.value, block.timestamp));
    }

    /* =============================================================
                            STEP 5
       Create withdraw() function
       It should:
       - Allow only owner
       - Accept amount
       - Require enough balance
       - Transfer ETH to owner
    ============================================================= */

    // TODO: Implement withdraw()
    function withdraw(uint256 amount) public{
        require(msg.sender == owner, "only owner can withdraw");
        require(amount <= totalBalance, "not enough balance");
        totalBalance -= amount;
        (bool success, ) = payable(owner).call{value: amount}("");
        require(success, "transfer failed");
    }
}


