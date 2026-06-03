pragma solidity ^0.5.11;

contract Event {
    /*
    Events:

    - Used to log data on the blockchain
    - Logs are stored in transaction receipts (not in contract storage)
    - Useful for frontends and off-chain applications to track activity

    Indexed parameters:
    - Allow filtering/searching logs by specific values
    - Up to 3 parameters can be indexed per event
    - Commonly used for addresses (e.g., sender)
    */

    // Event declaration with parameters
    event Log(address indexed sender, string message);

    // Event declaration without parameters
    event AnotherLog();

    function fireEvents () public {
        // Emit event with sender address and message
        emit Log(msg.sender, "Hello World!");

        // Emit another event with different message
        emit Log(msg.sender, "Hello EVM!");

        // Emit event without parameters
        emit AnotherLog();
    }


}