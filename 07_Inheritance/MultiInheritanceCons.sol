pragma solidity ^0.5.11; // Sets the Solidity compiler version 0.5.11 or compatible versions below 0.6.0.

/*
Multiple Inheritance and Constructors

Covers:
- How to call parent constructors
- Different ways to pass arguments to parent contracts
- Order of constructor execution (important in multiple inheritance)
- Note: Constructor execution order is determined by inheritance order,
  NOT by the order in which constructors are listed in the child
*/

// Parent/Base contract X
contract X {
    event Log(string message);
    string public name;

    constructor(string memory _name) public {
        name = _name;

        // Emit event to track execution order
        emit Log(_name);
    }
}

// Parent/Base contract Y
contract Y {
    event Log(string message);
    string public text;

    constructor(string memory _text) public {
        text = _text;

        // Emit event to track execution order
        emit Log(_text);
    }
}

/*
There are 2 ways to initialize parent contract with parameters.

Method 1: Passing fixed arguments directly in inheritance

- Arguments are hardcoded at the time of inheritance
- No constructor needed in the child contract
*/
contract B is X("Fixed Input"), Y("Another Fixed Input") {

}

/*
Method 2: Passing fixed arguments via the child constructor

- Parent constructors are called inside the child constructor
- Used when you want more control or logic
- No commas between parent calls here
*/
contract C is X, Y {
    constructor() X("Fixed Input") Y("Another Fixed Input") public {
    // Passing the parameters here in the inheritance list.
    }
}

/*
Method 3 (Version 1):

- Passing dynamic input from the child constructor
- Same value passed to both parent contracts
- Values are provided at deployment time

contract D is X, Y {
    constructor(string memory _name) X(_name) Y(_name) public {
    
    }
*/


/*
Method 3 (Version 2):
Method 3.2: Passing different dynamic inputs to each parent
Values are provided at deployment time
This is similar to function modifiers.
Order of constructors called:
1. X
2. Y
3. D
*/
contract D is X, Y {
    constructor(string memory _name, string memory _text) X(_name) Y(_text) public {
    
    }
}

/*
Constructor Execution Order:

- Parent constructors are executed in the order of inheritance (left → right)
- NOT based on the order in which they are called in the constructor of the child contract.

For both E and F:
- Inheritance is: X, Y
- So execution order is always:
  1. X constructor
  2. Y constructor
*/

// Order of constructors called:
// 1. X
// 2. Y
// 3. E
contract E is X, Y {
    constructor() X("X Was Called") Y("Y Was Called") public {}
}

// Order of constructors called:
// 1. X
// 2. Y
// 3. F
contract F is X, Y {
    constructor() Y("Y Was Called") X("X Was Called") public {}
}