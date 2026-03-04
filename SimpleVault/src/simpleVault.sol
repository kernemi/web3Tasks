// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract simpleVault {
    mapping (address => uint256) public balances;

    function deposit() external payable {
        require(msg.value >0,"NO ETH sent");
        balances[msg.sender] += msg.value;
    }
    
    function withdraw() external {
        uint256 amount= balances[msg.sender];
        require(amount > 0, "Not enough balance");

        balances[msg.sender] -= amount;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
    }
}
