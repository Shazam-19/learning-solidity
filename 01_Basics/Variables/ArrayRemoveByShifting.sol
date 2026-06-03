// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract ArrayRemoveByShifting {

    /*
    Array Removal by Shifting (Order Preserved)

    This approach removes an element by:
    1. Shifting all elements to the left starting from the target index
    2. Removing the duplicated last element using pop()

    Examples:
    [1, 2, 3] -- remove(1) --> [1, 3, 3] --> [1, 3]
    [1, 2, 3, 4, 5, 6] -- remove(2) --> [1, 2, 4, 5, 6, 6] --> [1, 2, 4, 5, 6]
    [1] -- remove(0) --> [1] --> []
    
    ⚠️ This method preserves order but is less gas-efficient (O(n)).
    */

    uint256[] public arr;

    // Removes the element at the given index while preserving order
    function remove(uint256 _index) public {

        // Ensure the index is valid
        require(_index < arr.length, "index out of bounds");

        // Shift elements to the left starting from `_index`
        // Each element takes the place of the next one
        for (uint256 i = _index; i < arr.length - 1; i++) {
            arr[i] = arr[i + 1];
        }

        // Remove the duplicated last element
        arr.pop();
    }

    // Test function to demonstrate and validate behavior
    function test() external {

        // Initialize array: [1, 2, 3, 4, 5]
        arr = [1, 2, 3, 4, 5];

        // Remove element at index 2 (value = 3)
        remove(2);
        // Expected: [1, 2, 4, 5]

        // Validate results
        assert(arr[0] == 1);
        assert(arr[1] == 2);
        assert(arr[2] == 4);
        assert(arr[3] == 5);
        assert(arr.length == 4);

        // Reset array to single element
        arr = [1];

        // Remove the only element
        remove(0);
        // Expected: []

        // Validate results
        assert(arr.length == 0);
    }
}

/*
Comparison: Array Removal Methods

1. Shifting Method (this contract)
   - Preserves the order of elements
   - Time Complexity: O(n) (loops through elements)
   - Gas Cost: Higher (more operations)
   - Use Case: When order matters

2. Compact Method (swap & pop)
   - Does NOT preserve order
   - Time Complexity: O(1)
   - Gas Cost: Lower (constant operations)
   - Use Case: When order does NOT matter


Real-World Usage:

- Use Shifting Method when:
  * Order is important (e.g., leaderboards, queues, sorted lists)
  * UI or logic depends on element position

- Use Compact Method when:
  * Order is NOT important
  * You need better gas efficiency
  * Working with large datasets (e.g., user lists, pools, mappings with arrays)

Best Practice:
- Choose the removal method based on your use case
- Avoid loops in large arrays when possible due to gas limits
- For scalable systems, consider alternative patterns (e.g., mappings + indexing)
*/