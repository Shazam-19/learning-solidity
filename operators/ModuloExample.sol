// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
 * ─────────────────────────────────────────────────────────────
 *  The Modulo Operator ( % )
 * ─────────────────────────────────────────────────────────────
 *
 *  Modulo returns the REMAINDER after integer division.
 *  It does NOT return the result of the division itself.
 *
 *  Formula:  a % b = remainder of (a ÷ b)
 *
 *  Quick reference:
 *  ┌────────────┬────────────────────────────┬──────────┐
 *  │ Expression │ Division                   │ Result   │
 *  ├────────────┼────────────────────────────┼──────────┤
 *  │  10 % 10   │ 10 ÷ 10 = 1, remainder 0   │    0     │
 *  │  10 %  9   │ 10 ÷  9 = 1, remainder 1   │    1     │
 *  │   2 %  2   │  2 ÷  2 = 1, remainder 0   │    0     │
 *  │   2 %  3   │  2 ÷  3 = 0, remainder 2   │    2     │
 *  │   2 %  6   │  2 ÷  6 = 0, remainder 2   │    2     │
 *  │   2 %  7   │  2 ÷  7 = 0, remainder 2   │    2     │
 *  └────────────┴────────────────────────────┴──────────┘
 *
 *  Key insight: whenever a < b, the result is always a itself,
 *  because b cannot divide into a even once (remainder = a).
 *
 *  Common use cases in Solidity:
 *  - Constraining a value to a range:  x % 10  always returns 0–9
 *  - Checking even/odd:                x %  2  returns 0 (even) or 1 (odd)
 *  - Selecting a random array index:   randomNumber % array.length
 * ─────────────────────────────────────────────────────────────
 */

contract ExampleModulo {

    /**
     * @notice Returns the remainder of dividing `number` by 10.
     * @dev    The result is always in the range [0, 9].
     *         Useful for extracting the last digit of a number,
     *         or wrapping a value into a fixed 10-slot range.
     *
     *         Examples:
     *           getModTen(10)  → 0   (10 ÷ 10 = 1, no remainder)
     *           getModTen(10)  → 0   (10 ÷ 10 = 1, no remainder)
     *           getModTen(23)  → 3   (23 ÷ 10 = 2, remainder 3)
     *           getModTen(100) → 0   (100 ÷ 10 = 10, no remainder)
     *           getModTen(7)   → 7   (7 ÷ 10 = 0, remainder 7)
     *
     * @param number  The input value to reduce.
     * @return        The remainder after dividing by 10 (always 0–9).
     */
    function getModTen(uint256 number) external pure returns (uint256) {
        return number % 10;
    }

    /**
     * @notice Returns the remainder of dividing `number` by 2.
     * @dev    The result is always 0 or 1, making this an even/odd check.
     *         This is also how Chainlink VRF random words are commonly used
     *         to select a winner: randomWord % players.length gives a valid index.
     *
     *         Examples:
     *           getModTwo(4)  → 0   even
     *           getModTwo(7)  → 1   odd
     *           getModTwo(0)  → 0   even
     *           getModTwo(1)  → 1   odd
     *
     * @param number  The input value to check.
     * @return        0 if even, 1 if odd.
     */
    function getModTwo(uint256 number) external pure returns (uint256) {
        return number % 2;
    }
}