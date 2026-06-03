// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
 * ─────────────────────────────────────────────────────────────
 *  Keccak256 — Cryptographic Hash Function
 * ─────────────────────────────────────────────────────────────
 *
 *  A hash function takes an input of arbitrary size and produces
 *  a fixed-size output (256 bits / 32 bytes for keccak256).
 *
 *  Key Properties:
 *  ┌───────────────────────┬──────────────────────────────────────────────────┐
 *  │ Deterministic         │ The same input always produces the same hash.    │
 *  │ Fast to compute       │ Hashing is efficient regardless of input size.   │
 *  │ One-way (irreversible)│ Given hash h, it is computationally infeasible   │
 *  │                       │ to recover the original input x.                 │
 *  │ Avalanche effect      │ A tiny change in input drastically changes the   │
 *  │                       │ output (e.g., "Shazam" vs "shazam" → very        │
 *  │                       │ different hashes).                               │
 *  │ Collision resistant   │ It is extremely hard to find two different inputs│
 *  │                       │ x and y such that hash(x) == hash(y).            │
 *  └────────────────────── ┴──────────────────────────────────────────────────┘
 *
 *  Common Use Cases in Solidity:
 *  - Generating a deterministic unique ID from structured data
 *  - Commit-Reveal schemes (submit a hash, reveal the value later)
 *  - Compact cryptographic signatures (sign the hash, not the full data)
 *  - Password / secret verification without storing the plaintext
 *
 * ─────────────────────────────────────────────────────────────
 *  ABI Encoding Methods
 * ─────────────────────────────────────────────────────────────
 *
 *  Solidity provides two ways to encode data before hashing:
 *
 *  abi.encode(...)
 *  - Pads each argument to 32 bytes (ABI-standard format).
 *  - Safe for all types, including multiple dynamic types (string, bytes).
 *  - Produces a longer byte output.
 *
 *  abi.encodePacked(...)
 *  - Tightly packs arguments with no padding.
 *  - More gas-efficient and produces shorter output.
 *  - ⚠️  Unsafe when encoding two or more dynamic types (string, bytes)
 *    together — different inputs can produce identical encoded bytes,
 *    causing a hash collision (see the `collision` function below).
 * ─────────────────────────────────────────────────────────────
 */

contract HashFunction {

    /*
     * A pre-computed hash stored as a state variable.
     * keccak256 is applied to the packed encoding of:
     *   - string  "Shazam"
     *   - uint256  1
     *   - address  0x000...007B  (decimal 123)
     *
     * This demonstrates that hashing can be done at the contract level,
     * not just inside functions.
     */
    bytes32 myHash = keccak256(abi.encodePacked("Shazam", uint256(1), address(123)));

    /*
     * @notice Hashes a combination of a string, a number, and an address.
     * @dev    Uses abi.encodePacked for gas efficiency.
     *         Avoid passing two or more dynamic types (string/bytes) with
     *         encodePacked — use abi.encode instead to prevent collisions.
     *
     * @param _text  A string value to include in the hash.
     * @param _num   A uint256 value to include in the hash.
     * @param _addr  An Ethereum address to include in the hash.
     * @return       The keccak256 hash of the packed-encoded inputs.
     */
    function hash(string memory _text, uint256 _num, address _addr)
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(_text, _num, _addr));
    }

    /*
     * Avalanche Effect — Demonstration
     *
     * Even a single character difference in the input produces a completely
     * different hash output:
     *
     *   keccak256("Shazam") =>
     *     0x20d6bbedd212d0b89ff83ac214ac13284ee75f25342b9352389205cb06056c38
     *
     *   keccak256("hazam") =>
     *     0xd8a6d99d888993e4d988f4d5a3c19c051aecb715edee73c011f9e9107c2f9580
     *
     * Notice how drastically different the two hashes are despite the inputs
     * differing by only one character. This is the avalanche effect in action.
     */

    /*
     * @notice Demonstrates hash collisions caused by packed encoding of
     *         two dynamic types.
     * @dev    abi.encodePacked concatenates values with no separator or padding.
     *         When two dynamic types (strings) are packed together, different
     *         combinations of inputs can produce identical byte sequences:
     *
     *           encodePacked("AAA", "BBB")  → bytes: AAABBB
     *           encodePacked("AA",  "ABBB") → bytes: AAABBB
     *
     *         Both byte sequences are identical → same hash → collision!
     *
     *         Fix: Use abi.encode instead of abi.encodePacked when hashing
     *         two or more dynamic types together.
     *
     * @param _text        First string input.
     * @param _anotherText Second string input.
     * @return             keccak256 hash of the packed-encoded strings.
     *
     * Collision example:
     *   collision("AAA", "BBB")  => 0xf6568e65...b7921358
     *   collision("AA",  "ABBB") => 0xf6568e65...b7921358  ← same hash!
     */
    function collision(string memory _text, string memory _anotherText)
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(_text, _anotherText));
        /*
        * Collision-safe alternatives (uncomment to use):
        *   Option A — abi.encode (no padding collision risk, slightly more gas):
        *     return keccak256(abi.encode(_text, _num, _addr));
        *
        *   Option B — hash each dynamic type individually before packing
        *              (safe but higher gas cost):
        *     return keccak256(abi.encodePacked(keccak256(bytes(_text)), _num, _addr));
        */
    }
}

/*
 * ─────────────────────────────────────────────────────────────
 *  GuessTheMagicWord — Commit-Reveal / Guessing Game Example
 * ─────────────────────────────────────────────────────────────
 *
 *  This contract stores the keccak256 hash of a secret word on-chain.
 *  Users can attempt to guess the word by submitting it to `guess()`.
 *  The contract hashes the submitted word and compares it to the stored answer.
 *
 *  Because the hash is one-way (irreversible), the secret word itself
 *  is never stored or revealed — only its hash is public.
 *
 *  This pattern is used in:
 *  - Password verification
 *  - Commit-reveal voting schemes
 *  - On-chain puzzle games
 * ─────────────────────────────────────────────────────────────
 */
contract GuessTheMagicWord {

    /*
     * The keccak256 hash of the secret magic word.
     * Stored publicly — anyone can see the hash, but the word itself
     * cannot be derived from it without brute-force guessing.
     */
    bytes32 public answer = 0x60298f78cc0b47170ba79c10aa3851d7648bd96f2f8e46a19dbc777c36fb0c00;

    /*
     * @notice Checks whether a submitted word matches the secret answer.
     * @dev    Hashes the input using keccak256(abi.encodePacked(...)) and
     *         compares it to the stored answer hash.
     *
     * @param _word  The word to test as a guess.
     * @return       True if the hash of `_word` matches `answer`; false otherwise.
     *
     * Example:
     *   guess("apple")    → false  (wrong word)
     *   guess("Solidity") → true   (if this is the magic word)
     */
    function guess(string memory _word) public view returns (bool) {
        return keccak256(abi.encodePacked(_word)) == answer;
    }
}