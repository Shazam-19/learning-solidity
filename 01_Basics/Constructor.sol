pragma solidity ^0.5.3; // Sets the compiler to use Solidity version 0.5.3 or compatible versions below 0.6.0.

contract A {

    // All variables are:
    // 1. Stored permanently on the blockchain
    // 2. public to automatically create a getter function

    uint public x;
    uint public y;

    // This declares a state variable owner of type address to store the address of the contract owner
    address public owner;

    // It will store the timestamp when the contract was deployed.
    uint public createdAt;

    // This is the constructor function.
    // It runs only once when the contract is deployed.
    constructor(uint _x, uint _y) public {
        x = _x;
        y = _y;

        owner = msg.sender; // Sets the contract deployer address as the owner.
        createdAt = block.timestamp; // Stores the current block timestamp (Unix time in seconds) at deployment.
    }
}