// SPDX-License-Identifier: MIT
// Declares the open-source license for this file.
// The MIT license allows anyone to use, copy, modify, and distribute this code freely.
// This comment is required by the Solidity compiler and must appear at the top of every file.

pragma solidity ^0.8.26;
// Specifies the Solidity compiler version this contract is compatible with.
// The caret (^) means "version 0.8.26 or any newer 0.8.x patch version, but not 0.9.x or higher."
// This protects against breaking changes introduced in future major versions.

/// @title Foo - A basic introductory Solidity contract
/// @notice Demonstrates state variables, structs, custom errors, and pure functions.
contract Foo {

    // -------------------------------------------------------------------------
    // STATE VARIABLES
    // -------------------------------------------------------------------------

    // A public string stored permanently on the blockchain.
    // Marking it `public` auto-generates a getter function, so anyone can call
    // `name()` to read this value without writing a separate function.
    string public name = "Foo";


    // -------------------------------------------------------------------------
    // STRUCTS
    // -------------------------------------------------------------------------

    // A struct is a custom data type that groups related variables under one name.
    // `Point` represents a 2D coordinate on a plane, defined by x and y values.
    // `uint256` is an unsigned (non-negative) 256-bit integer — the most common
    // integer type in Solidity, with a range of 0 to 2^256 - 1.
    struct Point {
        uint256 x; // Horizontal axis value
        uint256 y; // Vertical axis value
    }


    // -------------------------------------------------------------------------
    // CUSTOM ERRORS (COMMENTED OUT — FOR REFERENCE)
    // -------------------------------------------------------------------------

    // Custom errors were introduced in Solidity 0.8.4 as a gas-efficient
    // alternative to revert strings (e.g., revert("Unauthorized")).
    // They can carry parameters for richer debugging context.
    //
    // Usage example (if uncommented):
    //   if (msg.sender != owner) revert Unauthorized(msg.sender);
    //
    // error Unauthorized(address caller);


    // -------------------------------------------------------------------------
    // FUNCTIONS
    // -------------------------------------------------------------------------

    /// @notice Adds two unsigned integers and returns their sum.
    /// @dev Declared `pure` because it neither reads nor modifies blockchain state.
    ///      Declared `public` so it can be called by anyone — externally or internally.
    ///      Overflow protection is built in automatically from Solidity 0.8.0 onwards;
    ///      adding numbers that exceed uint256's max will cause the transaction to revert.
    /// @param x The first operand.
    /// @param y The second operand.
    /// @return The sum of x and y.
    function add(uint256 x, uint256 y) public pure returns (uint256) {
        return x + y;
    }

}