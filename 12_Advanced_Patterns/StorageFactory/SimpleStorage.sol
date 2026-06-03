// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
// pragma solidity >=0.8.0 <0.9.0;


/*
Basic Types & Storage Example

Demonstrates:
- Common Solidity data types
- State variables
- Default values
- Reading and writing state
*/

contract SimpleStorage {

    // Boolean (true/false)
    bool hasFavNum = true;

    // Unsigned integer (default visibility is internal)
    // `uint` is an alias for `uint256`
    uint256 public favNum = 88;

    // String (UTF-8 encoded text)
    string favNumInTxt = "eighty-eight";

    // Signed integer (can be negative)
    int256 favNegNum = -88;

    // Ethereum address (20 bytes)
    address myAddress = 0xF54EA090D66Ac6903cAE152d7E35EA0Ff59b42cc;

    // Fixed-size byte array (32 bytes)
    // "cat" is stored as bytes and padded with zeros
    bytes32 favBytes32 = "cat"; // 0x6361740000000000000000000000000000000000000000000000000000000000

    // Fixed-size (static) array (length = 3)
    // Cannot grow or shrink; all elements default to 0
    uint256[3] listOfFavNums;

    // Struct to represent a person and their favorite number
    struct Person {
        uint256 personFavNum; // Favorite number of the person
        string name;          // Name of the person
    }

    // Initialize a struct using named arguments (key-value style)
    // Order of fields does not matter when using this syntax
    Person public myFriend = Person({
        personFavNum: 7,
        name: "Mai"
    });

    // Dynamic Array
    Person[] public listOfPeople; // []
    
    // Ben -> 5
    mapping(string => uint256) public nameToFavNum;


    // Update the stored favorite number
    function store(uint256 _favNum) public {

        // Assign new value to state variable
        favNum = _favNum;
    }

    /*
    Read-only function (view):
    - Does NOT modify state
    - Free when called externally (no transaction gas cost)
    - Costs gas only when called internally by another function that modifies the state
    */
    function retrieve() public view returns (uint256) {

        return favNum;
    }


    // Add a new Person to the dynamic array `listOfPeople`

    // In Solidity, reference types like strings, arrays, and structs require
    // an explicit data location (memory, calldata, or storage) in function parameters and
    // return values, while state variables default to storage. 
    // Mappings can only exist in storage and have additional restrictions.

    function addPerson(string memory _name, uint256 _favNum) public {
        // Create a new Person struct in memory and push it to storage
        // Execution order:
        // 1. Create struct Person({...})
        // 2. Pass it into push()
        // 3. Store it in the array
        listOfPeople.push(Person({personFavNum: _favNum, name: _name}));

        nameToFavNum[_name] = _favNum;
    }
}

/*
The EVM can read and write to several places (easier edition)

Write & Read:
- Stack
- Memory
- Storage
- Calldata

Write (not read):
- Logs

Read (not write):
- Chain Data

===========================================================================

In Solidity, there are 3 main data locations: storage, memory, and calldata.

STORAGE
- Permanent data stored on the blockchain.
- Think of it like a database that keeps data forever.
- Expensive to read/write because it costs gas.
- Used for state variables (variables declared outside functions).

uint256 public storedValue; // lives in storage

function setValue(uint256 _value) public {
    storedValue = _value; // writing to storage (costly)
}


MEMORY
- Temporary data that exists only during function execution.
- Can be altered/modified dueing the function call
- Cleared after the function finishes.
- Cheaper than storage.
- Used for variables inside functions, especially arrays/structs.

function useMemory() public pure returns (uint256) {
    uint256 temp = 10; // stored in memory
    return temp;
}


CALLDATA
- Read-only data passed into functions (external calls).
- Cannot be modified.
- Cheapest data location.
- Used for function parameters, especially in external functions.

function useCalldata(uint256[] calldata data) external pure returns (uint256) {
    // data is read-only, cannot change it
    return data[0];
}

QUICK SUMMARY:
- storage  = permanent, expensive, blockchain data
- memory   = temporary, modifiable, exists during function call
- calldata = temporary, read-only, cheapest, used for inputs

*/