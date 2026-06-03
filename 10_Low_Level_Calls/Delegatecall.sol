// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
Delegatecall Overview
---------------------
- delegatecall is a low-level function similar to call.
- It allows a contract to execute code from another contract,
  but using its own storage, msg.sender, and msg.value.
  - msg.sender - Refer to the caller who called contract A in the example below
  - msg.value - Refer to the value that was sent to contract A in the example below
- Can upgrade contract A without changing any code inside it


Key Behavior:
- When contract A uses delegatecall to contract B:
  - The code of B is executed
  - The state (storage) of A is modified, NOT B
  - msg.sender remains the original external caller
  - msg.value remains the value sent to contract A

Use Case: Enables upgradeable contracts by separating logic (B) from storage (A).


Important Warning: delegatecall is powerful but dangerous.
- Storage mismatch = bugs
- Can overwrite critical variables
- Must be used carefully
*/

// NOTE: Deploy this contract first
contract B {
    // Storage layout MUST match contract A exactly for delegatecall to work correctly
    uint256 public num;
    address public sender;
    uint public value;

    // Updates state variables
    function setVars(uint256 _num) public payable {
        num = _num;           // Store input value
        sender = msg.sender;  // Store caller address
        value = msg.value;    // Store ETH sent
    }

}

// Alternative logic contract
contract B2 {
    // Same storage layout as A and B
    uint256 public num;
    address public sender;
    uint public value;

    // Slightly different logic: multiplies input by 2
    function setVars(uint256 _num) public payable {
        num = 2 * _num;       // Modify input before storing
        sender = msg.sender;
        value = msg.value;
    }

}

contract A {

    // Events to log results of delegatecall and call
    event DelegateResponse(bool success, bytes data);
    event CallResponse(bool success, bytes data);

    // Storage variables (must match B and B2 layout)
    uint256 public num;
    address public sender;
    uint public value;


    /*
    delegatecall example:
    - Executes external contract code (_contract)
    - Updates THIS contract's storage (A)
    - Does NOT modify storage of the target contract
    */
    function setVarsDelegateCall(address _contract, uint256 _num) public payable {
        // A's storage is set; B's storage is not modified.
        (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );

        // Emit result for debugging and tracking
        emit DelegateResponse(success, data);

    }



    /*
    call example:
    - Executes external contract code (_contract)
    - Updates TARGET contract's storage (B or B2)
    - Does NOT modify THIS contract's storage
    */
    function setVarsCall(address _contract, uint256 _num) public payable {
        // B's storage is set; A's storage is not modified.
        (bool success, bytes memory data) = _contract.call{value: msg.value}(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );

        // Emit result for debugging and tracking
        emit CallResponse(success, data);
    }

}

/*
Final Analogy:

call:
- You send a task to another contract.
- That contract executes it and updates its own state.

delegatecall:
- You import another contract's logic.
- It executes as if it were your own code and updates your state.
*/