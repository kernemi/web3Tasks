// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract OwnerMessageBoard {
    address public owner;
    string public message;

    event MessageUpdated(string newMessage);

    constructor(string memory _initialMessage) {
        owner = msg.sender;
        message = _initialMessage;
    }

    function updateMessage(string memory _newMessage) external {
        require(msg.sender == owner, "Not owner");

        message = _newMessage;
        emit MessageUpdated(_newMessage);
    }
}
