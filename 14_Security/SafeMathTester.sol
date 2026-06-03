// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

/*
Solidity < 0.8.0:
- Integer overflows and underflows are NOT checked automatically.
- Values wrap around when exceeding the maximum range.

Example:
uint8 max value = 255
255 + 1 = 0
*/

contract SafeMathTester {

    // uint8 range:
    // 0 -> 255
    uint8 public bigNumber = 255;

    function add() public {

        /*
        Overflow example:
        255 + 1 exceeds uint8 max value,
        so the value wraps back to 0.
        */
        bigNumber = bigNumber + 1;
    }
}



// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
Solidity >= 0.8.0:
- Integer overflows and underflows are checked automatically.
- Transactions revert on overflow by default.

To disable overflow checks, use 'unchecked'.
This word allows developers to bypass built-in overflow checks, 
potentially improving gas efficiency but increasing the risk of errors.


*/

contract SafeMathTester {

    // uint8 range:
    // 0 -> 255
    uint8 public bigNumber = 255;

    function add() public {

        /*
        unchecked:
        - Disables Solidity's automatic overflow checks
        - Restores the old wrap-around behavior

        Example:
        255 + 1 = 0
        */
        unchecked {
            bigNumber = bigNumber + 1;
        }
    }
}