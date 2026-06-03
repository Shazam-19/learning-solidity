pragma solidity ^0.5.3; // Sets the compiler to use Solidity version 0.5.3 or compatible versions below 0.6.0

contract ViewAndPure {
    // This declares a state variable x of type uint that is stored on the blockchain and initialized to 1.
    // public automatically creates a getter function.
    uint public x = 1;

    // The function is public and view, meaning it reads state but does not modify it.
    // We can't delare it as pure since it reads from the STORAGE using view
    function addToX(uint y) public view returns (uint) {
        return x + y; // This returns the sum of the state variable x and the input y.
    }

    /*
    - Invalid View Function
    - A view function cannot modify state variables, so this would cause an error.
    function updateX() public view {
        x += 1;
    }

    - A normal function that can modify state (even if empty here).
    function foo() public {}

    - If a function delared as view called another non-view function, it will be invalid
    - Why? Because it could modify the state which is not allowed by functions declared as view
    function invalidViewFunc() public view {
        foo();
    }
    */

    // If a function delared as pure called another non-pure function, it will be invalid
    // Why? Because it does not read and/or modify the state. It only works with it's inputs
    function add(uint i, uint j) public pure returns (uint) {
        return i + j;
    }
}