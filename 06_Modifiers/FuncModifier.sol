pragma solidity ^0.5.3; // Sets the compiler to use Solidity version 0.5.3 or compatible versions below 0.6.0.

/*
Examples:
1. Restricting write access (bascic syntax)
2. Valoidate inputs (inputs, why useful?)
3. Reentrancy guard (reentrancy hack)
*/

contract FuncModifier {

    // We will use these variables to demonstrate how to use modifiers.
    
    // Declares a state variable owner of type address.
    // It stores the address of the contract owner on the blockchain.
    address public owner; // public creates a getter function.
    uint public x = 10;
    bool locked; // This declares a boolean variable used to track whether a function is 
    // currently executing (for reentrancy protection).

    constructor() public {
        // Set the transaction (deployer of the contract) sender as the owner of the contract.
        owner = msg.sender;
    }

    // Important: The _; in a modifier is required because it tells Solidity where the actual function code should run.
    // If you forget it, the function will not execute correctly.

    // Modifiers can be called before and / or after a function.
    // Meaning that the  function code runs where _; is placed inside the modifier (usually after the checks, but can be before or after depending on placement).
    // In the case below, the function will run the modifier code, and then will run the code within the function.

    // Modifier to check that the caller is the owner of the contract.
    modifier onlyOwner() {
        // Checks that the caller is the owner. If not, the transaction reverts with an error message.
        require(msg.sender == owner, "Not Owner");
        _; // This represents where the actual function (changerOwner) code will execute.
    }

    // Modifiers can take inputs. This modifier checks that the
    // address passed in is not the zero address.
    modifier validAddress(address _addr) {
        require(_addr != address(0), "Not a Valid Address"); // Checks that the address is not the zero address.
        _; // Executes the rest of the function (changerOwner).
    }

    // Defines a function to change the contract owner. It uses two modifiers in order:
    // onlyOwner → only current owner can call
    // validAddress → new owner must not be zero address
    function changerOwner(address _newOwner) public onlyOwner validAddress (_newOwner){
        owner = _newOwner; // Updates the owner to the new address.
    }

    /*
    This is our code without modifiers if onlyOwner and validAddress were functions
    function changeOwner(address _newOwner) public {
        onlyOwner();
        validAddress(_newOwner);

        owner = _newOwner;
    }
    */


    // Reentrancy guard (reentrancy hack)

    // This modifier prevents a function from being called while it is still executing.
    modifier noReentrancy() { // Defines a modifier to prevent reentrancy attacks.
        require(!locked, "Locked"); // Make sure that the contract is NOT already in a locked state (== false).

        locked = true; // Locks the contract before executing the function.
        _; // Executes the function body.
        locked = false; // Unlocks the contract after execution.
    }

    // Using noReentrancy will break this function and blocks all re-entry including own recursive internal call
    function decrement(uint i) public noReentrancy {
        x -= 1; // Decreases the value of x by 1.

        if (i > 1) {
            decrement(i - 1); // Recursively calls itself with i - 1.
            // This recursion can consume a lot of gas if i is large
        }
    }
}

/*

🔹 Important: Modifiers are applied in order but executed as nested wrappers like: A wraps ( B wraps ( function ) ),
and the function body runs where _; is placed in each modifier and the execution is like:
    A {
         B {
             changerOwner
        }
     }

Or in a simple steps:
    1. A enters
    2. → B enters
    3. → function runs
    4. → B exits
    5. → A exits

🔹 Execution depends on _;

    Modifiers are not strictly executed top-to-bottom.
    Their behavior depends on where "_;" is placed.

    If modifiers change, execution flow also changes.

Example:

    modifier A {
        _;
        // runs AFTER function
    }

    modifier B {
        // runs BEFORE function
        _;
    }

    function foo() public A B { }

Execution flow becomes:

    B (before)
    → function body
    → A (after)


🔹 The real rule:

- Modifiers are nested wrappers around the function
- _; defines where the function body executes
- Execution order is NOT strictly linear
- It behaves like function wrapping, not sequential execution
*/