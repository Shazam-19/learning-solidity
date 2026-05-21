// SPDX-License-Identifier: MIT
// Declares the MIT open-source license for this file.
// Required by the Solidity compiler and must appear at the top of every source file.

pragma solidity ^0.8.26;
// Restricts compilation to Solidity 0.8.26 or any compatible 0.8.x patch version.
// Prevents accidental compilation with a breaking future version (e.g., 0.9.x).


// =============================================================================
// IMPORTS — Solidity supports three import styles:
//
//  1. LOCAL FILES     — files within the same project directory
//  2. NAMED/ALIASED   — selectively import specific symbols, optionally renamed
//  3. PACKAGE IMPORTS — external libraries resolved via npm or Foundry (forge install)
//
// Project structure assumed for this file:
//   TestImport/
//   ├── Import.sol   ← this file
//   └── Foo.sol      ← local dependency
// =============================================================================


// --- 1. LOCAL IMPORT ---------------------------------------------------------
// Imports ALL exported symbols (contracts, structs, errors, functions) from Foo.sol.
// Use this when you need everything the file exports.
import "./Foo.sol";


// --- 2. NAMED / ALIASED IMPORT (commented out — for reference) ---------------
// Imports only the specific symbols you need, reducing namespace pollution.
// Symbols can be renamed with `as` to avoid naming conflicts.
//
// Syntax:  import {SymbolA as Alias, SymbolB} from "path/to/file.sol";
//
// import {Unauthorized, add as func, Point} from "./Foo.sol";


// --- 3. REMOTE PACKAGE IMPORT via GitHub URL -------------------------------------

// This imports the battle-tested ERC20 base contract from OpenZeppelin,
// providing the complete standard token implementation out of the box.
//
// Source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v5.0/contracts/token/ERC20/ERC20.sol
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


// =============================================================================
// CONTRACT: Import
// Demonstrates how to instantiate and interact with another local contract
// (Foo.sol) from within a separate contract file.
// =============================================================================
contract Import {

    // Deploys a new instance of the Foo contract and stores its reference.
    // `public` auto-generates a getter so callers can retrieve the deployed address.
    // `new Foo()` runs Foo's constructor and assigns the resulting contract instance.
    Foo public foo = new Foo();

    /// @notice Reads and returns the `name` state variable from the deployed Foo contract.
    /// @dev Marked `view` because it reads blockchain state but does not modify it.
    ///      `string memory` is required for dynamic types returned from external calls;
    ///      `memory` means the value is held temporarily during execution, not stored on-chain.
    /// @return The value of `foo.name()`, which is the string "Foo".
    function getFooName() public view returns (string memory) {
        return foo.name();
    }
}


// =============================================================================
// CONTRACT: MyToken
// A minimal ERC20 token that inherits the full standard implementation from
// OpenZeppelin. `is ERC20` means MyToken extends ERC20, gaining all of its
// functions (transfer, approve, balanceOf, etc.) automatically.
// =============================================================================
contract MyToken is ERC20 {

    /// @notice Initialises the token with a fixed name and ticker symbol.
    /// @dev The `constructor() ERC20("MyToken", "MTK")` syntax calls the parent
    ///      ERC20 constructor before this contract's own initialisation logic runs.
    ///      - "MyToken" → the human-readable token name  (accessible via name())
    ///      - "MTK"     → the abbreviated ticker symbol   (accessible via symbol())
    ///      No tokens are minted here; add a `_mint(msg.sender, amount)` call
    ///      inside this constructor body if an initial supply is required.
    constructor() ERC20("MyToken", "MTK") {}
}