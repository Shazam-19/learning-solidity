// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Loop {
    uint256 public count; // Value starts at 0 by default

    // Loops in Solidity must always be used carefully.
    // There should always be an upper bound to avoid excessive gas consumption.

    function loop(uint256 n) public {
        // 🔁 FOR LOOP: runs from i = 0 to i < n
        for (uint256 i = 0; i < n; i++) {

            // Increment state variable on each iteration
            count +=1;

            // Skip the rest of this iteration when i equals 3,
            // and moves directly to the next value of i (which will be 4)
            if (i == 3) {
                continue;
            }
            if (i == 5) {
                // Stop the loop completely when i equals 5,
                // so no more iterations after this point
                break;
            }
        }

        /*
        // 🔁 WHILE LOOP: runs until condition becomes false
        uint256 j;

        // Increment j until it reaches 10
        while (j < 10) {
            j++;
        }
        */
    }
}