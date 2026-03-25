// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StakingPool {

    /* =============================================================
                            STEP 1
       Create a Stake struct.
       It must store:
       - amount (uint256)
       - startTime (uint256)
       - claimed (bool)
    ============================================================= */

    // TODO: Define struct here
    struct Stake {
        uint256 amount;
        uint256 startTime;
        bool claimed;
    }

    /* =============================================================
                            STEP 2
       Create state variables:
       - owner (address)
       - rewardRate (uint256)  // reward per second
       - mapping to track user stakes
    ============================================================= */

    // TODO: Declare owner
    address public owner;
    
    // TODO: Declare rewardRate
    uint256 public rewardRate;

    
    // TODO: Declare stakes mapping
    mapping(address => Stake) public stakes; 

    /* =============================================================
                            STEP 3
       Create constructor
       It should:
       - set owner = msg.sender
       - set rewardRate
    ============================================================= */

    // TODO: Implement constructor
    constructor(uint256 _rewardRate) {
        owner = msg.sender;
        rewardRate = _rewardRate;
    }

    /* =============================================================
                            STEP 4
       Create stake() function
       It should:
       - Be payable
       - Require msg.value > 0
       - Store stake amount
       - Store startTime
       - Set claimed = false
    ============================================================= */

    // TODO: Implement stake()
    function stake() external payable {
        require(msg.value > 0, "Must stake more than 0");
        stakes[msg.sender] = Stake({
            amount: msg.value,
            startTime: block.timestamp,
            claimed: false
        });
    }

    /* =============================================================
                            STEP 5
       Create calculateReward() function
       It should:
       - Take user address
       - Calculate staking duration
       - reward = duration * rewardRate
       - Return reward
    ============================================================= */

    // TODO: Implement calculateReward()
    function calculateReward(address user) public view returns (uint256) {
        Stake memory userStake = stakes[user];
        if (userStake.claimed) {
            return 0; // No reward if already claimed
        }
        uint256 stakingDuration = block.timestamp - userStake.startTime;
        uint256 reward = stakingDuration * rewardRate;
        return reward;
    }

    /* =============================================================
                            STEP 6
       Create unstake() function
       It should:
       - Get user's stake
       - Require not already claimed
       - Calculate reward
       - Mark claimed = true
       - Transfer stake + reward to user
    ============================================================= */

    // TODO: Implement unstake()
    function unstake() external {
        Stake storage userStake = stakes[msg.sender];
        require(!userStake.claimed, "Stake already claimed");
        uint256 reward = calculateReward(msg.sender);
        userStake.claimed = true;
        payable(msg.sender).call{value: userStake.amount + reward}("");

    }

}
