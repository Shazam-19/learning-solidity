// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
 * ─────────────────────────────────────────────────────────────
 *  Error Handling in Solidity — revert vs require
 * ─────────────────────────────────────────────────────────────
 *
 *  Solidity provides two primary ways to reject invalid transactions
 *  and roll back state changes:
 *
 *  revert CustomError()
 *  - Introduced in Solidity 0.8.4 as "custom errors".
 *  - Encodes only a 4-byte error selector (the function signature hash).
 *  - Does NOT store an error string on-chain → significantly lower gas cost.
 *  - Preferred in production contracts for gas efficiency.
 *
 *  require(condition, "message")
 *  - The traditional approach, available since early Solidity.
 *  - Reverts if the condition is false, storing the full error string.
 *  - The string is ABI-encoded and included in the revert data → higher gas cost.
 *  - Still widely used for its readability and simplicity.
 *
 *  Gas Comparison (this contract):
 *  ┌──────────────────────┬──────────┐
 *  │ revertWithError()    │ 140 gas  │
 *  │ revertWithRequire()  │ 160 gas  │
 *  └──────────────────────┴──────────┘
 *
 *  The difference grows larger as the error message string gets longer.
 *  For hot paths or frequently-called functions, custom errors are preferred.
 * ─────────────────────────────────────────────────────────────
 */

contract ExampleRevert {

    /*
     * Custom error declaration.
     *
     * Custom errors are defined with the `error` keyword and follow the
     * naming convention: ContractName__ErrorName (double underscore).
     * This convention helps identify which contract an error originated from,
     * which is especially useful in complex, multi-contract systems.
     *
     * Custom errors can optionally carry parameters to provide more context:
     *   error ExampleRevert__Error(address caller, uint256 value);
     *
     * Here, no parameters are needed — the error type alone is sufficient.
     */
    error ExampleRevert__Error();

    /*
     * @notice Demonstrates reverting with a custom error.
     * @dev    Uses a custom error instead of a string message, which costs
     *         less gas because only a 4-byte error selector is returned
     *         (rather than a full ABI-encoded string).
     *
     *         The condition here is hardcoded to `false`, so the revert
     *         is never actually triggered — this function always succeeds.
     *         This is intentional: it shows the gas cost of the revert
     *         PATH existing in code, not of the revert being executed.
     *
     * Gas cost: ~140 gas
     */
    function revertWithError() public pure {
        if (false) {
            revert ExampleRevert__Error();
        }
    }

    /*
     * @notice Demonstrates reverting with a require statement.
     * @dev    Uses require() with a string error message, which costs more
     *         gas than a custom error because the string is ABI-encoded and
     *         included in the revert data.
     *
     *         The condition here is hardcoded to `true`, so the require
     *         never fails — this function always succeeds.
     *         Like revertWithError(), this is intentional: it isolates and
     *         compares the gas cost of each error-handling approach.
     *
     * Gas cost: ~160 gas
     */
    function revertWithRequire() public pure {
        require(true, "ExampleRevert_Error");
    }
}