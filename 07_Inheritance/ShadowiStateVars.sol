pragma solidity ^0.5.11; // Sets the Solidity compiler version (0.5.11 or compatible below 0.6.0).

contract A {
    // State variable stored on-chain with an automatic getter
    string public name = "Contract A";

    // Returns the current value of 'name'
    function getName() public view returns (string memory) {
        return name;
    }
}

/*
State Variable Shadowing:

- In Solidity < 0.6.0, it was possible (but discouraged) to redeclare
  a state variable with the same name in a child contract.
- Starting from Solidity 0.6.0, this is disallowed and causes a compilation error.

Example (invalid in newer versions):

contract B is A {
    string public name = "Contract B"; // ❌ Shadowing parent variable
}
*/

contract C is A {
    /*
    Correct approach to "override" a state variable:

    - Do NOT redeclare the variable
    - Instead, modify the inherited variable (e.g., in the constructor)
    - Note: Inherited state variables can be modified anywhere (constructor or functions),
      as long as they are not redeclared.
    */
    constructor() public {
        name = "Contract C"; // Updates the inherited state variable
    }

    // Calling getName() will now return "Contract C"
}
