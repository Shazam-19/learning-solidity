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
        bytes memory someString = abi.encode("Shazam!");
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
        bytes memory someString = abi.encodePacked("Shazam!");
        return someString;
    }
}