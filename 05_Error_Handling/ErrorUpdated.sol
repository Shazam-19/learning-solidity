// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Error {
    function testRequire(uint256 _i) public pure {
        // `require` is used to validate external inputs and conditions before execution.
        // It is commonly used for:
        // - Input validation
        // - Preconditions for function execution
        // - Validating return values from external calls to other functions
        require(_i > 10, "Input must be greater than 10");
    }

    function testRevert(uint256 _i) public pure {
        // `revert` is useful for handling complex conditional logic.
        // It immediately stops execution and undoes all state changes.
        // Functionally, this is equivalent to the `require` check above.
        if (_i <= 10) {
            revert("Input must be greater than 10");
        }
    }

    uint256 public num; // Automatically initialized to 0

    function testAssert() public view {
        // `assert` is used to detect internal errors and verify invariants.
        // It should only be used for conditions that should NEVER fail.
        // If it fails, it indicates a serious bug in the contract logic.

        // Since `num` is never modified, it is expected to always remain 0 == true.
        assert(num == 0);
    }

    // Custom error definition for gas-efficient error handling
    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

    function testCustomError(uint256 _withdrawAmount) public view {
        uint256 bal = address(this).balance; // Gets the contract’s ETH balance
        if (bal < _withdrawAmount) { // Checks if balance is less than _withdrawAmount
        
            // It reverts using the custom error InsufficientBalance
            // Returns both current balance and requested amount
            revert InsufficientBalance({
                balance: bal,
                withdrawAmount: _withdrawAmount
            });
        }
    }
}
