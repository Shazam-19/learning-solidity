pragma solidity ^0.5.3; // Sets the compiler to use Solidity version 0.5.3 or compatible versions below 0.6.0.

/*
Examples
- Inheritance
  - Inherit functions
  - Override functions

- Passing parameters to partent constructor
  - Fixed parameters
  - Variable parameters
*/

// Parent Contract A
contract A {
    function getContractName() public pure returns (string memory) {
        return "Contract A"; // Return a string stored in memory.
    }
}

// When overriding a function, the child must use the exact same function signature
// (same name, parameters, and return types) as the parentthe parent has to be the same
contract B is A { // Child Contract B
    function getContractName() public pure returns (string memory) {
        return "Contract B"; // Overrides the parent function and returns "Contract B" instead.
    }
}

/*
Invalid example:
Changing the function signature (e.g., adding parameters) does NOT override the parent function.
Instead, it creates a new function, leaving the original parent function unchanged.

contract B is A {
    function getContractName(uint i) public pure returns (string memory) {
        return "Contract B";
    }
}
*/

// Parent Contract
contract C {
    string public name; // Variable of type string that's stored on the blockchain with an automatic getter.
    constructor (string memory _name) public {
        name = _name;
    }
}

/*
Passing parameters to the partent constructor:
Method 1: inline with inheritance
    // Child Contract
    contract D is C ("Contract D") {

    }


Method 2: inside the child constructor
    contract D is C {
    constructor() C("Contract D") public {

    }
}

*/

// Passing dynamic (variable) parameters from the child constructor to the parent constructor
contract D is C {
    // Constructor that takes _name as input and passes it to the parent constructor C
    constructor(string memory _name) C(_name) public {
    }
}

