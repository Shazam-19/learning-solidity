// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
Examples:
- Declaring arrays (dynamic and fixed-size)
- Using push, pop, and length
- Removing elements from arrays (two approaches)
*/

contract Array {
    // Several ways to initialize an array

    // 1. Dynamic array (can grow or shrink)
    uint256[] public arr;

    // 2. Dynamic array initialized with values
    uint256[] public arr2 = [1, 2, 3];
    
    // Fixed-size array (length is always 10)
    // All elements are initialized to 0 by default (uint256 default value is 0)
    uint256[10] public myFixedSizeArr;

    
    // Returns the element at index `i` from `arr`
    function get(uint256 i) public view returns (uint256) {
        return arr[i];
    }


    // Returns the entire array
    // ⚠️ Avoid using this for very large arrays due to gas and memory costs
    function getArr() public view returns (uint256[] memory) {
        return arr;
    }
    
    // Appends a new element to the end of the array
    // Increases array length by 1
    function push(uint256 i) public {
        arr.push(i);
    }

    // Removes the last element of the array
    // Decreases array length by 1
    function pop() public {
        arr.pop();
    }

    // Returns the current number of elements in the array
    function getLength() public view returns (uint256) {
        return arr.length;
    }

    // ⚠️ Does NOT either reduce array length or remove elements.
    // Instead, it resets the value at that index to the default (0 for uint256)
    function remove(uint256 index) public {
        delete arr[index];
    }

    // Alternative array for demonstrating compact removal, by copying the last element
    // into the index we want to delete
    uint256[] public compactArray;

    // Removes an element by replacing it with the last element
    // Then removes the last element to keep the array compact
    // ⚠️ This method does NOT preserve order but it's efficient (O(1))
    function removeCompact(uint256 index) public {
        compactArray[index] = compactArray[compactArray.length - 1];
        compactArray.pop();
    }

    // Test function demonstrating how compact removal works
    function testCompact() public {

        // Initialize array: [1, 2, 3, 4]
        compactArray.push(1);
        compactArray.push(2);
        compactArray.push(3);
        compactArray.push(4);

        // Remove element at index 1 (value = 2)
        // Replace it with last element (4), then remove last
        // Result: [1, 4, 3]
        removeCompact(1);

        // Validate expected results
        assert(compactArray.length == 3);
        assert(compactArray[0] == 1);
        assert(compactArray[1] == 4);
        assert(compactArray[2] == 3);

        // Remove element at index 2 (value = 3)
        // Replace with last element (itself), then remove last
        // Result: [1, 4]
        removeCompact(2);

        // Validate expected results
        assert(compactArray.length == 2);
        assert(compactArray[0] == 1);
        assert(compactArray[1] == 4);

    }

    
    // Advanced: Example of creating arrays in memory (temporary, not stored on-chain), that:
    // - Exist only during function execution
    // - Cheaper than storage
    // - Only fixed size can be created in memory

    function examples() external pure {

        // Create a dynamic-type array in memory with fixed length = 5
        // All values are initialized to 0 by default
        // a = [0, 0, 0, 0, 0]
        uint256[] memory a = new uint256[](5);

        // create a nested array / 2D array (array of arrays) in memory
        // Think of this like a table (rows and columns)
        // Create outer array with length = 2
        // At this point:
        // b = [empty, empty]
        // (inner arrays are not created yet)
        uint256[][] memory b = new uint256[][](2); // It's mandatory to define array size when creating it in memeory

        // 📌 IMPORTANT:
        // Each element of `b` is itself an array, but currently uninitialized
        // We must create each inner array manually as in the function below...


        // Initialize inner arrays
        for (uint256 i = 0; i < b.length; i++) {

            // For each index in outer array:
            // Create an inner array with length = 3
            b[i] = new uint256[](3);

            // After loop:
            // b = [
            //   [0, 0, 0],
            //   [0, 0, 0]
            // ]
        }

        // 📌 Assign values manually

        // First row
        b[0][0] = 1;
        b[0][1] = 2;
        b[0][2] = 3;

        // Second row
        b[1][0] = 4;
        b[1][1] = 5;
        b[1][2] = 6;
    }
    
    // Final structure of b:
    // b = [
    //   [1, 2, 3],
    //   [4, 5, 6]
    // ]

    /*
    Why did we write the b implementation like that?
    Because 2D arrays = arrays inside arrays, so we must:
    1. Create outer array
    2. Then create each inner array
    3. Then assign values
    */
}
