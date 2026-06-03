// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*

Ether Transfer & Receiving Example

There are 3 ways to send Ether from a contract to another contract:

- transfer → forwards 2300 gas, reverts on failure (not recommended)
- send     → forwards 2300 gas, returns bool (not recommended)
- call     → forwards all gas (or custom), returns bool (recommended)

Receiving Ether:
A contract must implement at least one of:
- receive() → called when msg.data is empty
- fallback() → called when msg.data is NOT empty

Note: receive() is called if msg.data is empty, otherwise fallback() is called.

Which method should you use?
Use 'call' in combination with re-entrancy guard is the recommended method to use after December 2019.

Guard against re-entrancy by:
- Making all state changes before calling other contracts
- Using re-entrancy guard modifier (not shown in this example)
*/

contract ReceiveEther {
    /*
    Which function is called, fallback() or receive()?

           send Ether
               |
         msg.data is empty?
                / \
              yes  no
              /     \
        receive()   exists? --> fallback()
          /   \
        yes   no
        /      \
    receive()   fallback()
    */



    // Called when Ether is sent with empty msg.data
    // Example: sending Ether via transfer/send/call without data

    receive() external payable {} // Ether is accepted and added to contract balance


    // Called when msg.data is NOT empty OR receive() does not exist
    fallback() external payable {} // Also accepts Ether, but typically used for handling unknown function calls


    // Returns the current Ether balance of this contract
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

contract SendEther {

        // Method 1: transfer (NOT recommended)

    function sendViaTransfer(address payable _to) public payable {
        // Sends msg.value Ether to the address `_to`
        // - Forwards only 2300 gas
        // - Automatically reverts on failure
        // - Can break if receiver needs more gas
        _to.transfer(msg.value);
    }

    // Method 2: send (NOT recommended)
    function sendViaSend(address payable _to) public payable {

        // Sends msg.value Ether to the address `_to`
        // - Forwards only 2300 gas
        // - Returns true/false instead of reverting
        bool sent = _to.send(msg.value);

        // Manually revert if failed
        require(sent, "Failed to Send Ether");
    }

    // Method 3: call (RECOMMENDED)
    function sendViaCall(address payable _to) public payable {
        // and we can also specifiy the amount of gas if we want to

        // Sends msg.value Ether using low-level call
        // - Forwards all remaining gas by default
        // - Returns 2 values: success or faliure flag AND returned data
        // - Most flexible and widely used method
        (bool sent, bytes memory data) = _to.call{value:msg.value}("");

        // Note: since the fallback() function can't return any values,
        // the 'data' will be returned as 0 bytes. Usually, 'data' is how we call other
        // functions from other contracts.

        // Ensure the transfer succeeded
        require(sent, "Failed to send Ether");

        // Send Ether with a custom gas limit (e.g., 5000 gas)
        // (bool sent, bytes memory data) = _to.call{value: msg.value, gas: 5000}("");
        // But if the receiver needs more than the specified amount → ❌ transaction fails
    }
}
