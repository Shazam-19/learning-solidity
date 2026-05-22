// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
Library
- No storage, no ether
- Helps you keep your code DRY (Don't Repeat Yourself)
  - Add functionality types
    // uint x
    // x.myFuncFromLibrary()
- Can save gas. How can this be actually saving gas?

Embedded or Linked
- Embedded (library has only internal functions)
- Must be deployed and then linked (library has public or external functions)

Examples
- Safe math (prevent 'uint' overflow)
- Deleting element from array without gaps
*/

library SafeMath {
    function add(uint256 x, uint256 y) internal pure returns(uint256) {
        uint256 z = x + y;
        require(z >= x, "uint overflow");

        return z;
    }
}

contract TestSafeMath {
    using SafeMath for uint256;
    // Using A for B
    // Attach functions from library A to type B

    // To test for overflow, we call 'testAdd' it with MAX_INT
    uint constant public MAX_UINT = 2**256 - 1;

    function testAdd(uint256 x, uint256 y) public pure returns (uint256) {
        return x.add(y);
        // or we can return it like this
        // SafeMath.add(x, y);
    }
}

// This will allow us to remove any element from any array wihout any gaps
library Array {
    function remove(uint[] storage arr, uint256 index) public {
        arr[index] = arr[arr.length - 1];
        arr.pop();
    }
}

contract TestArray {
    using Array for uint[];

    uint[] public arr;

    function testArrayRemove() public {
        for (uint256 i = 0; i < 3; i++) {
            arr.push(i);
        }

        // [0, 1, 2]

        arr.remove(1);

        // arr[index] = arr[arr.length - 1]; ==> [0, 2, 2]
        // arr.pop(); ==> [0, 2]

        assert(arr.length == 2);
        assert(arr[0] == 0);
        assert(arr[1] == 2);
    }
}
