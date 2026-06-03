// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
Low-level call in Solidity

Key Concepts:
- `call` is a low-level function available on all addresses
- It allows interaction with other contracts without requiring their interface
- It is flexible but unsafe compared to high-level function calls

Use cases:
- Calling existing functions on another contract
- Calling non-existing functions (triggers fallback)
- Sending Ether with custom gas control

⚠️ Best Practice:
Avoid using `call` unless necessary, as it bypasses compile-time checks.

Few reasons why low-level call is not recommended:
- Reverts are not bubbled up
- Type checks are bypassed
- Function existence checks are omitted
*/

contract Reciever {

    // Event emitted when either foo(), fallback(), or receive() is triggered
    event Received(address caller, uint256 amount, string message);

    /*
    fallback():
    - Triggered when:
        • Function does not exist
        • OR calldata does not match any function signature
    - Can receive Ether since it's marked as payable
    */
    fallback() external payable {
        emit Received(msg.sender, msg.value, "Fallback was called");
    }


    /*
    Example function that can be called via low-level call
    - Accepts Ether
    - Returns input value + 1
    */
    function foo(string memory _message, uint256 _x) public payable returns (uint256) {
        emit Received(msg.sender, msg.value, _message);

        return _x + 1;
    }

    /*
    receive():
    - Triggered when Ether is sent with empty calldata
    - Used for plain Ether transfers
    */
    receive() external payable {}

}

contract Caller {

    // Event to log success/failure of low-level calls and returned data
    event Responce(bool success, bytes data);


    /*
    Calls the `foo` function on another contract using a low-level call

    Key Points:
    - Function signature is manually encoded using ABI encoding
    - Ether can be sent along with the call
    - Gas limit can be explicitly specified
    - Low-level calls do not enforce function existence or return types
    */
    function textCallFoo(address payable _address) public payable {
        
        // Low-level call to function foo(string,uint256)
        // "call foo" and 123 are the arguments passed to foo()
        (bool success, bytes memory data) = _address.call{
            value: msg.value,
            gas: 5000
            // Note: Spaces inside the function signature do NOT matter
            // e.g. "foo(string,uint256)" == "foo(string, uint256)"
        }(abi.encodeWithSignature("foo(string,uint256)", "call foo", 123));

        // The return value of foo(uint256) is encoded in `data` (bytes)
        // It must be decoded manually to use it

        // The responce 'data' will give us (after foo() returns) this hexadecimal value:
        // 0x000000000000000000000000000000000000000000000000000000000000007c
        // Which corresponds to 124 (123 + 1) in decimal
        emit Responce(success, data);
    }


    /*
    Calls a non-existent function on the target contract

    Behavior:
    - Since function does not exist, fallback() is triggered on receiver
    - No compile-time validation of function existence
    - We don't have to send Ether when sending the call method, so we removed 'payable'
    from the function argument and visibility
    */
    function testCallDoesNotExist(address _address) public {
        
        // This will trigger the fallback function since we don't have 'doesNotExist()'
        // Fallback() does not return any outputs, so 'data' will be 0 bytes
        (bool success, bytes memory data) = _address.call(
            abi.encodeWithSignature("doesNotExist()")
        );

        // The responce 'data' will give us (after fallback() returns) this hexadecimal value: 0x
        // which is basically 0 bytes
        emit Responce(success, data);
    }
}