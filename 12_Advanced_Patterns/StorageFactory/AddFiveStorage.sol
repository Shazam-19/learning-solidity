// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;


// Import the SimpleStorage contract to inherit its state variables and functions
import {SimpleStorage} from "./SimpleStorage.sol";

/*
AddFiveStorage Contract

Purpose:
- Demonstrates inheritance in Solidity
- Extends the behavior of SimpleStorage
- Overrides the `store()` function to modify how values are saved

Important: When overriding a function, you must use the same state variables
defined in the parent contract. Renaming a variable (e.g., favNum → favNum1)
will cause a compilation error unless the new variable is explicitly declared.

Inherited state variables must be referenced exactly as defined.
*/

contract AddFiveStorage is SimpleStorage {

    /*
    Simple example function
    - Does not read or modify state
    - Marked as `pure` because it only returns a constant value
    */
    function sayHello() public pure returns (string memory) {
        return "Shazam!";
    }

    /*
    Override the `store()` function from SimpleStorage

    Key Concepts:
    - `override` indicates that this function replaces the parent implementation
    - The original function in SimpleStorage must be marked `virtual`
    - This version modifies the input before storing it
    */
    function store(uint256 _favNum) public override {

        // Store the input value + 5 instead of the original value
        favNum = _favNum + 5;
    }

}