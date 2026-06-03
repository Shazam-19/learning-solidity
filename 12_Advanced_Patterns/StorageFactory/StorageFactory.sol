// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Import the SimpleStorage contract so we can deploy and interact with it
import {SimpleStorage} from "./SimpleStorage.sol";
// import {SimpleStorage1, SimpleStorage2} from "./SimpleStorage.sol"; // Importing multiple contracts

/*
StorageFactory Contract

Purpose:
- Acts as a manager that can deploy multiple SimpleStorage contracts
- Stores references (addresses) to those deployed contracts
- Allows interaction with each deployed contract
*/

contract StorageFactory {

    // uint256     public         favNum
    // Type        Visibility     name

    /*
    Dynamic array of SimpleStorage contract instances
    - Each element represents a deployed SimpleStorage contract
    - Solidity stores the contract address internally
    */
    SimpleStorage[] public listOfSimpleStorageContracts;


    /*
    Deploy a new SimpleStorage contract and store its reference

    Key Concept:
    - Using `new` deploys a fresh contract on-chain
    - The returned value is the contract instance (address + ABI access)
    */
    function createSimpleStorageContract () public {

        // Here we are telling the compiler to deploy the contract SimpleStorage
        SimpleStorage newsimpleStorageContract = new SimpleStorage();

        listOfSimpleStorageContracts.push(newsimpleStorageContract);
    }


 

    /*
    Store a new value in a specific SimpleStorage contract

    Parameters:
    - _simpleStorageIndex: index of the target contract in the array
    - _simpleStorageNumber: new value to store in that contract

    Key Concept:
    - Demonstrates how to call a state-changing function on another contract
    - Uses the contract instance directly (no casting required)

    Notes:
    - Uses the Application Binary Interface (ABI) of SimpleStorage to call its `store()` function
    - ABI tells our code exactly how it can interact with another contract
    */
    function sfStore(
        uint256 _simpleStorageIndex,
        uint256 _simpleStorageNumber
    ) public {

        // Access the target contract and update its stored value
        listOfSimpleStorageContracts[_simpleStorageIndex].store(
            _simpleStorageNumber
        );

        /*
        Alternative approach (not needed here):

        If we only had an address, we would need to cast it:
        SimpleStorage(address(...)).store(_simpleStorageNumber);

        Important:
        Since `listOfSimpleStorageContracts` already stores
        SimpleStorage contract instances, casting is unnecessary.
        */
    }



    /*
    Function 'Storage Factory Store' which retrieve the stored value
    from a specific SimpleStorage contract.

    Parameters:
    - _simpleStorageIndex: index of the deployed contract in the array

    Notes:
    - Uses the Application Binary Interface (ABI) of SimpleStorage to call its `retrieve()` function
    - Marked as `view` because it only reads data (no state change)
    - ABI tells our code exactly how it can interact with another contract
    */
    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        /*
        Interaction Methods (equivalent approaches):
        1. Direct contract call (recommended)
        2. Casting from stored contract reference
        3. Casting from raw address (using ABI)

        All methods ultimately achieve the same result: calling `retrieve()` on the target contract.
        */

        // Approach 1 (recommended):
        // Directly access the contract instance and call its function
        return listOfSimpleStorageContracts[_simpleStorageIndex].retrieve();

        /* 
        // Approach 2: Assign contract instance first, then call function
        SimpleStorage simpleStorageContract = listOfSimpleStorageContracts[_simpleStorageIndex];
        
        return simpleStorageContracts.retrieve();
        */

        /*
        Important regarding Approach 2: Since listOfSimpleStorageContracts already stores
        SimpleStorage contract instances, there is no need to cast.
        
        The following is redundant:
        'SimpleStorage(listOfSimpleStorageContracts[_simpleStorageIndex])'

        We only use casing on addresses, for example:
        address[] public addresses;
        SimpleStorage s = SimpleStorage(addresses[i]); // ✅ required
        */

        // Approach 3: Explicitly cast from address (less common when already typed)
        // return SimpleStorage(address(listOfSimpleStorageContracts[_simpleStorageIndex])).retrieve();
    
    }
}