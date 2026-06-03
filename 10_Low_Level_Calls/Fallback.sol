// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
The fallback function is a special function that's executed when:
1. A function that does not exist is called
2. Ether is sent to the contract and:
   - receive() does not exist, OR
   - msg.data is NOT empty

Fallback function:
- transfer/send → forward 2300 gas (very limited as it can't write to storage or call another contract with this gas amount)
- call → forwards all gas (default)

It’s not recommended to include extensive logic inside the fallback function,
since operations like transfer and send can fail.

Best practices:
- Keep fallback logic minimal
- Avoid heavy computations to reduce the risk of failure

*/


contract Fallback {

    // Event to log which function was triggered and remaining gas
    event Log(string func, uint256 gas);

    /*
    fallback():
    - Must be 'external'
    - Must be 'payable' to receive Ether
    - Called when:
        • Calling a function that does not exist in the contract we sent the transaction to
        • OR msg.data is not empty A.K.A sending Ether with data to call functions in other contracts
    */
    fallback() external payable {

        // gasleft() returns remaining gas at this point in execution
        emit Log("fallback", gasleft());

    }


    /*
    receive():
    - Preferred way to receive plain Ether transfers
    - Called when:
        • Ether is sent
        • AND msg.data is empty A.K.A sending Ether transaction only without data
    */    receive() external payable {

        emit Log("receive", gasleft());

    }


    // Helper function that returns the Ether balance of this contract
    function getBalance() public view returns (uint256) {

        return address(this).balance;

    }
}


contract SendToFallback {

    // Sends Ether using transfer()
    function transferToFallback(address payable _to) public payable {

        // Forwards 2300 gas → likely triggers receive() if msg.data is empty
        _to.transfer(msg.value);

    }


    // Sends Ether using call()
    function callFallback(address payable _to) public payable {

        // Empty data "" → triggers:
        // - 'receive()' (if exists),
        // - otherwise 'fallback()' (if receive doesn't exist)
        (bool sent,) = _to.call{value: msg.value}("");

        require(sent, "Failed to send Ether");

    }


    /* 
    Sends Ether with arbitrary non-empty calldata ("0x1234"), resulting in:
    - Since msg.data is NOT empty, this will trigger fallback() on the receiver
    (if it exists), otherwise the transaction may revert
    - Forwards all remaining gas by default
    */
    function callWithData(address payable _to) public payable {

        // Low-level call with custom data payload
        (bool sent, ) = _to.call{value: msg.value}("0x1234");
        
        require(sent, "Failed to send Ether");
    }


    /* 
    Calls a function that does NOT exist on the target contract, resulting in:
    - The encoded signature "doesNotExist()" will not match any function
    - This forces execution of fallback() on the receiving contract
    - Useful for testing fallback behavior
    */
    function callNonExisting(address payable _to) public payable {
        
        // Encode a non-existent function signature and send it via call
        (bool sent, ) = _to.call{value: msg.value}(
            abi.encodeWithSignature("doesNotExist()")
        );

        require(sent, "Call failed");
    }

}

/*
Real-world usage
- Upgradeable contracts
- Proxy contracts
- ETH receivers (donations, vaults)
- Handling unexpected calls
*/
