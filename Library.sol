// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
 * SOLIDITY LIBRARIES
 * ------------------
 * A library is a reusable piece of code that can be shared across contracts.
 *
 * Key properties:
 * - Cannot store state (no state variables)
 * - Cannot receive Ether
 * - Helps keep code DRY (Don't Repeat Yourself)
 *
 * How to attach a library to a type:
 *   using LibraryName for SomeType;
 *   This lets you call library functions directly on variables of that type.
 *   Example:
 *     uint256 x = 5;
 *     x.add(3); // calls SafeMath.add(x, 3)
 *
 * Two deployment types:
 * - Embedded: library only has internal functions → compiled into the contract,
 *             no separate deployment needed, saves gas.
 * - Linked:   library has public or external functions → must be deployed
 *             separately and linked to the contract at deployment time.
 *
 * Common use cases:
 * - SafeMath: protect against integer overflow (less relevant since Solidity 0.8+
 *             which has built-in overflow checks, but useful for learning)
 * - Array utilities: operations like removing elements without leaving gaps
 */

// -----------------------------------------------------------------------------
// LIBRARY: SafeMath
// Provides safe arithmetic operations that revert on overflow.
// Note: Solidity 0.8+ handles overflow automatically, but this is a great
// example of how libraries work and why SafeMath existed before 0.8.
// -----------------------------------------------------------------------------
library SafeMath {
    // Adds two uint256 values and reverts if the result overflows.
    // 'internal' means this function is embedded into any contract that uses it.
    // 'pure' means it does not read or modify contract state.
    function add(uint256 x, uint256 y) internal pure returns (uint256) {
        uint256 z = x + y;
        // If z is less than x, an overflow occurred.
        // Example: MAX_UINT + 1 wraps around to 0, which is less than MAX_UINT.
        require(z >= x, "uint overflow");
        return z;
    }
}

// -----------------------------------------------------------------------------
// CONTRACT: TestSafeMath
// Demonstrates how to attach a library to a type using 'using...for'.
// -----------------------------------------------------------------------------
contract TestSafeMath {
    // Attach all SafeMath functions to the uint256 type.
    // After this, any uint256 variable can call SafeMath functions as methods.
    using SafeMath for uint256;

    // The maximum value a uint256 can hold: 2^256 - 1
    // Used to test overflow behaviour.
    uint256 public constant MAX_UINT = 2 ** 256 - 1;

    // Adds two uint256 values using the SafeMath library.
    // Calling x.add(y) is equivalent to SafeMath.add(x, y).
    function testAdd(uint256 x, uint256 y) public pure returns (uint256) {
        return x.add(y);
        // Alternative syntax (without 'using...for'):
        // return SafeMath.add(x, y);
    }
}

// -----------------------------------------------------------------------------
// LIBRARY: Array
// Provides utility functions for dynamic arrays.
// This library uses 'public' visibility, so it must be deployed and linked.
// -----------------------------------------------------------------------------
library Array {
    // Removes the element at the given index from a storage array
    // without leaving a gap, by replacing it with the last element.
    //
    // Strategy:
    //   1. Copy the last element into the position to delete.
    //   2. Remove the last element with pop().
    //
    // Example:
    //   arr = [10, 20, 30, 40], remove index 1
    //   Step 1: arr[1] = arr[3]  →  [10, 40, 30, 40]
    //   Step 2: arr.pop()        →  [10, 40, 30]
    //
    // Important: this does NOT preserve element order.
    function remove(uint256[] storage arr, uint256 index) public {
        require(arr.length > 0, "Cannot remove from an empty array");
        // Overwrite the target element with the last element
        arr[index] = arr[arr.length - 1];
        // Remove the duplicate at the end
        arr.pop();
    }
}

// -----------------------------------------------------------------------------
// CONTRACT: TestArray
// Demonstrates how to use the Array library to remove elements without gaps.
// -----------------------------------------------------------------------------
contract TestArray {
    // Attach Array library functions to the uint256[] type.
    using Array for uint256[];

    uint256[] public arr;

    // Populates the array, removes an element, and verifies the result.
    function testArrayRemove() public {
        // Fill the array: [0, 1, 2]
        for (uint256 i = 0; i < 3; i++) {
            arr.push(i);
        }

        // Remove element at index 1 (value: 1)
        // Step 1: arr[1] = arr[2]  →  [0, 2, 2]
        // Step 2: arr.pop()        →  [0, 2]
        arr.remove(1);

        // Verify the array is now [0, 2] with no gaps
        assert(arr.length == 2);
        assert(arr[0] == 0);
        assert(arr[1] == 2);
    }
}