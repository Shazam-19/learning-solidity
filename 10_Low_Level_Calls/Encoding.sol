// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// Solidity cheatsheet reference: https://docs.soliditylang.org/en/v0.8.13/cheatsheet.html

/**
 * @title Encoding
 * @notice Demonstrates how Solidity encodes data into bytes using ABI encoding,
 *         and how that relates to how the EVM reads and executes transactions.
 */
contract Encoding {

    /**
     * @notice Combines two strings into one using abi.encodePacked.
     * @dev abi.encodePacked concatenates values tightly without padding into bytes,
     *      then casting to string gives us the final readable result.
     * @return A single string: "Hi Mom! Miss you."
     */
    function combineStrings() public pure returns (string memory) {
        return string(abi.encodePacked("Hi Mom! ", "Miss you."));
    }

    // -----------------------------------------------------------------------
    // BACKGROUND: Transactions, Bytecode, and the EVM
    // -----------------------------------------------------------------------
    //
    // When you deploy a contract or call a function, Solidity compiles your
    // code into BYTECODE; raw binary instructions sent in the transaction's
    // `data` field.
    //
    // Example deployment transaction on Etherscan:
    // https://etherscan.io/tx/0x112133a0a74af775234c077c397c8b75850ceb61840b33b23ae06b753da40490
    //
    // That bytecode is made up of OPCODES — 2-character hex instructions that
    // tell the EVM exactly what to do (e.g., ADD, STORE, CALL).
    //
    // Opcode references:
    //   https://www.evm.codes/
    //   https://ethereum.org/developers/docs/evm/opcodes/
    //   https://github.com/crytic/evm-opcodes
    //
    // The EVM (Ethereum Virtual Machine) is the engine that reads and executes
    // these opcodes. Any blockchain that implements the EVM can run Solidity
    // contracts — which is why Polygon, Avalanche, and others are EVM-compatible.
    //
    // TIP: In Remix or Hardhat, compile your contract and inspect the
    // "Bytecode" output. Click "Assembly" to see the human-readable opcodes.
    // -----------------------------------------------------------------------

    // -----------------------------------------------------------------------
    // ABI ENCODING
    // -----------------------------------------------------------------------
    //
    // ABI (Application Binary Interface) encoding is how Solidity converts
    // values (numbers, strings, addresses) into bytes the EVM understands.
    // This is the same format used when calling contract functions externally.
    // -----------------------------------------------------------------------

    /**
     * @notice ABI-encodes the number 1 into its raw bytes representation.
     * @dev abi.encode pads values to 32 bytes, matching the EVM's word size.
     *      Example: abi.encode(1) returns:
     *      0x0000000000000000000000000000000000000000000000000000000000000001
     * @return The number 1 as a 32-byte ABI-encoded value.
     */
    function encodeNumber() public pure returns (bytes memory) {
        bytes memory number = abi.encode(1);
        return number;
    }

    /**
     * @notice ABI-encodes a string into its raw bytes representation.
     * @dev abi.encode adds a 32-byte offset, a 32-byte length prefix, and
     *      pads the string content to a multiple of 32 bytes.
     *      This padded format is required when calling external contract functions.
     *      Example: abi.encode("some string") produces ~96 bytes.
     * @return The string "some string" as padded ABI-encoded bytes.
     */
    function encodeString() public pure returns (bytes memory) {
        bytes memory someString = abi.encode("some string");
        return someString;
    }

    /**
     * @notice Encodes a string using packed encoding (no padding).
     * @dev abi.encodePacked compresses values tightly without 32-byte padding,
     *      producing a much smaller byte output than abi.encode.
     *      Use this for: hashing (keccak256), string concatenation, gas savings.
     *      Do NOT use this for: calling external functions (padding is required).
     *
     *      Comparison:
     *        abi.encode("some string")       → ~96 bytes (padded)
     *        abi.encodePacked("some string") → 11 bytes  (compact)
     *
     *      Reference: https://forum.openzeppelin.com/t/difference-between-abi-encodepacked-string-and-bytes-string/11837
     * @return The string "some string" as compact packed bytes.
     */
    function encodeStringPacked() public pure returns (bytes memory) {
        bytes memory someString = abi.encodePacked("some string");
        return someString;
    }

    /**
    * @notice Converts a string literal directly to bytes using type casting.
    * @dev `bytes("some string")` is a direct type cast; it produces the same
    *      compact output as abi.encodePacked for a single string, but has
    *      slightly different gas costs and is not suitable for multi-value packing.
    *      Use abi.encodePacked when combining multiple values.
    * @return The string "some string" as raw bytes via type casting.
    */
    function encodeStringBytes() public pure returns (bytes memory) {
        bytes memory someString = bytes("some string");
        return someString;
    }

    /**
    * @notice Decodes ABI-encoded bytes back into a readable string.
    * @dev abi.decode reverses abi.encode by reading the padded byte structure
    *      and extracting the original value at the specified type.
    *      The type must match exactly what was used during encoding.
    *
    *      Example:
    *        abi.encode("some string")                → padded bytes
    *        abi.decode(paddedBytes, (string))        → "some string"
    *
    * @return The decoded string "some string" extracted from its ABI-encoded form.
    */
    function decodeString() public pure returns (string memory) {
        string memory someString = abi.decode(encodeString(), (string));
        return someString;
    }

    /**
    * @notice ABI-encodes two strings together into a single bytes object.
    * @dev abi.encode supports multiple values in one call, each padded to 32 bytes.
    *      The result is larger than encoding a single string because it contains
    *      offsets, lengths, and padded content for each value.
    *
    *      Example:
    *        abi.encode("some string", "it's bigger!") → ~192 bytes (padded)
    *
    * @return Both strings ABI-encoded together as a single padded bytes object.
    */
    function multiEncode() public pure returns (bytes memory) {
        bytes memory someString = abi.encode("some string", "it's bigger!");
        return someString;
    }

    /**
    * @notice Decodes a multi-value ABI-encoded bytes object back into two strings.
    * @dev abi.decode can extract multiple values at once when given a tuple of types.
    *      The types provided must match the order and types used during encoding.
    *
    *      Example:
    *        Input:  abi.encode("some string", "it's bigger!")
    *        Output: ("some string", "it's bigger!")
    *
    * @return someString      The first decoded string: "some string".
    * @return someOtherString The second decoded string: "it's bigger!".
    */
    function multiDecode() public pure returns (string memory, string memory) {
        (string memory someString, string memory someOtherString) = abi.decode(multiEncode(), (string, string));
        return (someString, someOtherString);
    }
}