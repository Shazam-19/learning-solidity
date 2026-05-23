// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
Keccak256 (Cryptographic Hash Function)
- What is it?
  - Function that takes in arbitary size input and outputs a data of fixed size
  - Properties:
    - Deterministic
      - hash(x) = h (every time)
    - Quick to compute the hash
    - Irreversible
      - Given h, hard to fix x such that hash(x) = h
    - Small change in the input (x) changes the output (h) significantly
    - Collision resistant
      - Hard to find x, y such that hash(x) = hash(y)

Example
- Guessing game (pseudo random)


keccak256 computes the Keccak-256 hash of the input.

Some use cases are:

- Creating a deterministic unique ID from an input
- Commit-Reveal scheme
- Compact cryptographic signature (by signing the hash instead of a larger input)
- Solidity provides two methods for encoding data:

abi.encode:
- Encodes data into bytes with padding
- Preserves all data information
- Safer when dealing with dynamic types
- Produces a longer output due to padding
abi.encodePacked:
- Performs packed encoding (compressed)
- Produces a shorter output than abi.encode
- More gas efficient
- Risk of hash collisions with dynamic types (collision function)
*/

contract HashFunction {
    // encodePacked takes in all types of data and any amount of inputs and trun them into bytes
    bytes32 myHash = keccak256(abi.encodePacked("Shazam", uint256(1), address(123)));

    function hash(string memory _text, uint256 _num, address _addr) 
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(_text, _num, _addr));

        // To prevent the collision from happening, we simply need to call 'encode' only
        // return keccak256(abi.encode(_text, _num, _addr)); - cheaper gas
        // or
        // return keccak256(abi.encodedPacked(keccak256(str1), keccak256(str2))); - more gas 
    }

    // Hasing comparasion
    // 0x20d6bbedd212d0b89ff83ac214ac13284ee75f25342b9352389205cb06056c38 - Shazam
    // 0xd8a6d99d888993e4d988f4d5a3c19c051aecb715edee73c011f9e9107c2f9580 - hazam

    // Example of hash collision
    // Hash collision can occur when you pass more than one dynamic data type
    // to abi.encodePacked. In such case, you should use abi.encode instead.
    function collision(string memory _text, string memory _anotherText) public pure returns (bytes32)
    {
        // encodePacked(AAA, BBB) -> AAABBB
        // encodePacked(AA, ABBB) -> AAABBB
        // This collision happened because we passed more than one (two) dynamic data type
        return keccak256(abi.encodePacked(_text, _anotherText));
    }

    // 0xf6568e65381c5fc6a447ddf0dcb848248282b798b2121d9944a87599b7921358 - AAA BBB
    // 0xf6568e65381c5fc6a447ddf0dcb848248282b798b2121d9944a87599b7921358 - AA ABBB
}


contract GuessTheMagicWord {
    bytes32 public answer = 0x60298f78cc0b47170ba79c10aa3851d7648bd96f2f8e46a19dbc777c36fb0c00;

    function guess(string memory _word) public view returns (bool) {
        return keccak256(abi.encodePacked(_word)) == answer;
    }
}