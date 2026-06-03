pragma solidity ^0.5.3; // Set the compiler to use Solidity version 0.5.3 or compatible versions below 0.6.0.

contract EtherUnits {
    // Declare a state variable oneWei of type uint (Unsigned Integer) which is stored on the blockchain..
    uint public oneWei = 1 wei; // Public means Solidity automatically creates a getter function.
    // 1 wei is the smallest unit of Ether, so this stores the value 1.

    // Declare a state variable oneEther of type uint (Unsigned Integer) which is stored on the blockchain..
    uint public oneEther = 1 ether;
    // 1 ether is automatically converted by Solidity into 1e18 wei (which is 1,000,000,000,000,000,000).

    // The function is public so anyone can call it
    function testOneWei () public pure returns (bool) { // It is marked pure, meaning it does not read or modify blockchain state.
        return 1 wei == 1; // Returns a bool (true or false).
    }

    // The function is public so anyone can call it
    function testOneEther () public pure returns (bool) { // It is marked pure, meaning it does not read or modify blockchain state.
        return 1 ether == 1e18 wei;
    }
}

/*
Important:
Gas is slightly different in the two functions because the compiler treats constants differently at the EVM level. 
`1 wei == 1` uses a very small constant that is encoded more efficiently, while `1 ether == 1e18 wei` involves a much larger constant (1e18), 
which requires more stack operations and slightly more bytecode handling. 

Even though both expressions are logically equivalent and computed at compile time, the EVM still executes different low-level instructions, 
resulting in a small gas difference (258 vs 214).


Gas difference is about:

How many bytes / stack operations are needed to represent the constant in bytecode

NOT:

Which unit is bigger (wei vs ether)
*/
