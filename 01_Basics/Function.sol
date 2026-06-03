pragma solidity ^0.8.26; // Sets the compiler to use Solidity version 0.8.26 or compatible newer versions within the 0.8 range

contract Function {
    // Functions can return multiple values.
    // It is public and pure, meaning it does not read or modify state.
    function returnMany() public pure returns (uint256, bool, uint256) { // It returns three values: a uint256, a bool, and another uint256.
        return (1, true, 2); // This returns three values at once.
    }

    // Return values can be named.
    // Define a function where the return values are named (x, b, y).
    // It is public and pure, meaning it does not read or modify state.
    function named() public pure returns (uint256 x, bool b, uint256 y) {
        return (1, true, 2); // Returns values in the same order as the named variables.
    }

    // Return values can be assigned to their name.
    // In this case the return statement can be omitted.
    function assigned() public pure returns (uint256 x, bool b, uint256 y) {
        x = 1;
        b = true;
        y = 2;
        // No return statement is needed because values are already assigned.
    }

    // Use destructuring assignment when calling another
    // function that returns multiple values.
    function destructuringAssignments()
        public
        pure
        returns (uint256, bool, uint256, uint256, uint256)
    {
        (uint256 i, bool b, uint256 j) = returnMany();

        // Values can be left out.
        // This uses destructuring assignment. The middle value (5) is ignored.
        (uint256 x,, uint256 y) = (4, 5, 6); 

        return (i, b, j, x, y);
    }

    // Cannot use map for either input or output

    // Can use array for input
    // This defines a function that takes an array as input.
    // The array is stored in memory (temporary).
    function arrayInput(uint256[] memory _arr) public {}

    // Can use array for output
    // This declares a dynamic array stored on the blockchain.
    uint256[] public arr; // public creates a getter for individual elements.

    // This defines a function that returns the array.
    function arrayOutput() public view returns (uint256[] memory) {
        return arr; // Returns the entire array (copied into memory).
    }
}

// Call function with key-value inputs
contract XYZ {
    function someFuncWithManyInputs(
        uint256 x,
        uint256 y,
        uint256 z,
        address a,
        bool b,
        string memory c
    ) public pure returns (uint256) {} // The function body is empty, so it returns the default value (0).

    // External functions cannot be called inside the contract without using this.funcName()
    // Otherwise it results in a compilation error.
    function callFunc() external pure returns (uint256) {
        return someFuncWithManyInputs(1, 2, 3, address(0), true, "c");
        // Calls the function using positional arguments (order matters) but still will return 0.
    }

    // External functions cannot be called inside the contract without using this.funcName()
    // Otherwise it results in a compilation error.
    function callFuncWithKeyValue() external pure returns (uint256) {
        // Calls the function using key-value arguments (order does not matter).
        return someFuncWithManyInputs({
            a: address(0),
            b: true,
            c: "c",
            x: 1,
            y: 2,
            z: 3
        });
    }
}

/*
Notes: 
🔹 What will NOT work inside the contract
callFunc(); // ❌ error
callFuncWithKeyValue(); // ❌ error

This fails because external functions are not visible for internal calls.

🔹 What WILL work
this.callFunc(); // ✅ works
this.callFuncWithKeyValue(); // ✅ works

But this:
- Makes an external call to the contract itself
- Costs more gas
- Uses a different execution context

*/