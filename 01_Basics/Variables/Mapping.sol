// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
Mapping Basics:
- Declare a mapping (key → value)
- Read a value
- Update (set) a value
- Reset (delete) a value

Important Notes:
- Mappings are not iterable (you cannot loop through keys/values like arrays).
- Mappings do not store length or list of keys.
- To track keys, you must use an additional data structure (e.g., an array).

General Mapping Constraints:
- Keys must be value types (address, uint, bool, etc.)
- Values can be any type (including arrays, structs, or mappings)
*/

contract Mapping {

    // Mapping from address → uint256
    // - Key: address (e.g., user wallet)
    // - Value: uint256 (e.g., balance or score)
    mapping(address => uint256) public myMap;

    // Returns the value associated with a given address
    function get(address _addr) public view returns (uint256) {
        // Mappings always return a value.
        // If no value was set, it returns the default:
        // - uint256 → 0
        // - bool → false
        // - address → address(0)
        return myMap[_addr]; // Similar in how we access an index in an array
    }

    // Sets or updates the value for a given address
    function set(address _addr, uint256 _i) public {
        // Assign value `_i` to `_addr`
        // If the key already exists → value is overwritten
        myMap[_addr] = _i;
    }

    // Resets the value for a given address
    function remove(address _addr) public {
        // `delete` resets the value to its default
        // It does NOT remove the key (since mappings don't track keys)
        delete myMap[_addr];
    }
}