pragma solidity ^0.5.3; // Set the compiler to use Solidity version 0.5.3 or compatible versions below 0.6.0.

contract Gas {
    // The function is marked view, meaning it only reads data and does not modify the blockchain's state.
    function testGasRefund() public view returns (uint) { // It is public, so anyone can call it.
        return tx.gasprice; // This returns the gas price of the current transaction.
        // tx.gasprice is the amount of wei the sender is willing to pay per unit of gas.
    }

    uint public i = 0; // Declares a uint state variable i stored on the blockchain, initialized to 0, and marked public, which automatically creates a getter function.

    // It's a public function, so anyone can call it.
    function forever() public { // It is not marked view or pure, so it can modify state.
        while (true) { // This creates an infinite loop that will never stop on its own.
            i +=1;
            // This increases the value of i by 1 on every loop iteration.
            // Each update writes to storage, which costs gas.
        }
    }
}