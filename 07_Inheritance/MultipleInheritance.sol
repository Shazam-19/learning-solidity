pragma solidity ^0.5.11; // Sets the Solidity compiler version (0.5.11 or compatible below 0.6.0).

/*
Example 1: Multiple Inheritance (no conflict)

- Contract C inherits from both A and B
- Since function names are different (foo and bar), there is no conflict
- C can access both functions without any issue

contract A {
    function foo() public pure returns (string memory) {
        return "A";
    }
}

contract B {
        function bar() public pure returns (string memory) {
        return "B";
    }
}

contract C is A, B {

}
*/

/*
Example 2: Function Name Conflict

- Both A and B define a function with the same name (foo)
- Solidity resolves this using inheritance order (right-to-left)
- The function from the right-most parent (B) takes priority
- If not found in B, Solidity continues searching left (A)

Note: Inheritance order is critical when functions have the same signature
*/
contract A {
    function foo() public pure returns (string memory) {
        return "A";
    }
}

contract B {
    function foo() public pure returns (string memory) {
        return "B";
    }
}

contract C is A, B {

}

/*
Inheritance Order Rule:
- Solidity uses a method resolution order (similar to depth-first, right-to-left search) to determine which function implementation to use
- Contracts must be listed from base → more derived
- The compiler uses C3 linearization to resolve inheritance order
- Incorrect ordering will result in a compilation error
*/
contract D is A, C { // Important: Contract C already inherits from A and B (D → C → B → A)

}

/*
Notes:
- Solidity ensures each contract appears only once
- It merges inheritance hierarchies in a consistent order
- Avoids duplication and ambiguity
*/


// Demonstrates how function calls behave in inheritance,
// specifically the difference between direct parent calls F.foo()
// and using "super" keyword like super.foo() (which follows Solidity's inheritance linearization)
contract F {
    // Event used to track which function is being executed
    event Log(string message);

    function foo() public {
        emit Log("F. foo was called");
    }

    function bar() public {
        emit Log("F.bar called");
    }
}

contract G is F {
    function foo() public {
        emit Log("G.foo called");

        // Direct call to parent contract F
        // This ignores inheritance order and always calls F.foo()
        F.foo(); // Calls F.foo() directly → always executes F.foo() (no inheritance logic)
    }

    function bar() public {
        emit Log("G.bar called");

        // Calls the next implementation of bar() in the inheritance chain
        // based on Solidity's linearization (not necessarily F directly)
        super.bar();
    }
}

contract H is F {
    function foo() public {
        emit Log("H.foo called");

        // Direct call to parent contract F (same behavior as in G)
        F.foo();
    }

    function bar() public {
        emit Log("H.bar called");

        // Uses super to continue execution in the inheritance chain
        super.bar();
    }
}

// Multiple inheritance: I inherits from G and H
// Order matters → right-to-left priority (H is checked before G)
contract I is G, H {

}

/*
Execution behavior when calling I.bar():

- Solidity determines the linearized inheritance order (C3 linearization)
- For contract I (is G, H), the order becomes: I → H → G → F

Call flow for I.bar():
1. H.bar() is called first (right-most parent)
2. H.bar() calls super.bar() → goes to G.bar()
3. G.bar() calls super.bar() → goes to F.bar()
4. F.bar() executes and ends the chain

So the execution order is:
H.bar → G.bar → F.bar

Key takeaway:
- super does NOT mean "call immediate parent"
- It means "call the next function in the linearized inheritance chain"
- Direct calls like F.foo() bypass this chain completely
*/