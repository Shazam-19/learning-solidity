pragma solidity ^0.5.11;

/*
 * Assert:
 * - Used for internal checks
 * - Should never fail
 * - Consumes all remaining gas on failure
 *
 * Require:
 * - Used for input validation and preconditions
 * - Reverts if conditions are not met
 * - Refunds remaining gas
 *
 * Revert:
 * - Used to manually trigger a rollback
 * - Can include custom error messages
 */

contract Account {
    uint public balance;

    // Maximum value representable by a uint256 (2^256 - 1),
    // as a fixed constant and cannot be changed
    uint public constant MAX_UINT = 2 ** 256 - 1;

    function deposit(uint _amount) public {
        //Main Idea: balance + _amount does not overflow if balance + _amount >= balance

        // Store the previous balance for validation
        uint oldBalance = balance;

        // Calculate the new balance
        uint newBalance = balance + _amount;

        // Prevent overflow (when numbers exceed the max limit): 'new balance' must be >= 'old balance'
        // If overflow happens, the transaction is canceled.
        require(newBalance >= oldBalance, "Overflow");
        
        // Update the contract balance
        balance = newBalance;

        // Double-checks that the balance increased correctly by using 'assert',
        // which is used for internal consistency checks.
        assert (balance >= oldBalance);
    }


    function withdraw(uint _amount) public {
        // Main Idea: balance - _amount does not underflow if balance >= _amount

        // Store the previous balance for validation
        uint oldBalance = balance;

        // Prevent underflow: ensure sufficient balance before withdrawal
        require(balance >= _amount, "Underflow");

        // Subtract the withdrawal amount
        balance -= _amount;

        // Additional safety check for underflow (redundant but explicit)
        // but it's not really needed due to 'require'
        if (balance < _amount) {
            revert("Underflow");
        }

        // Sanity check: balance should not increase after withdrawal.
        // so this line ensures that the balance actually decreased
        assert (balance <= oldBalance);
    }

}

/*
Note:
This contract manually checks for overflow/underflow because it uses Solidity 0.5.
In modern Solidity (≥0.8.0), these checks are built-in automatically,
so we usually don’t need this logic.
*/