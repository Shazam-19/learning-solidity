pragma solidity ^0.5.11;

contract Base {
    /*
    Function Visibility Levels:

    - private: accessible only within this contract
    - internal: accessible within this contract and derived (child) contracts
    - public: accessible internally and externally (via transactions or other contracts)
    - external: accessible only from outside the contract (cannot be called internally without using 'this')
    */

    // Contracts that inherit this function, cannot call it,
    // so we can't call this function after deployment.
    function privateFunc() private pure returns (string memory) { // // PRIVATE: Only callable inside this contract
        return "private function called";
    }

    // Public wrapper to access private function
    function testPrivateFunc() public pure returns (string memory) {
        return privateFunc();
    }

    // Internal functions can be called:
    // - Inside this contract
    // - Inside contracts that inherit this contract
    function internalFunc() internal pure returns (string memory) {
        return "internal function called";
    }

    // Public wrapper to access internal function
    function testInternalFunc() public pure returns (string memory) {
        return internalFunc();
    }

    // Public functions can be called:
    // - Inside this contract
    // - Inside contracts that inherit this contract
    // - By other contracts and accounts
    function publicFunc() public pure returns (string memory) {
        return "public function called";
    }

    // External functions can only be called by other contracts and accounts
    function externalFunc() external pure returns (string memory) {
        return "external function called";
    }

    /*
    Invalid example:

    - External functions cannot be called internally using direct calls
    - Must use 'this.externalFunc()' for an external call (not recommended due to extra gas)

    function testExternalFunc() public pure returns (string memory) {
        return externalFunc(); // ❌ Compilation error
    }
    */


    /*
    State Variable Visibility:

    - private: only accessible within this contract
    - internal: accessible within this contract and inherited contracts
    - public: creates an automatic getter function
    - external: NOT allowed for state variables
    */

    string private privateVar = "my private variable";
    string internal internalVar = "my internal variable";
    string public publicVar = "my public variable";

    // State variables cannot be declared as external, so the below code won't compile.
    // string external externalVar = "my external variable";

    /*
    Important Note:

    - private and internal do NOT hide data from the blockchain
    - All data on-chain is publicly readable
    - These keywords only restrict access at the contract level, not visibility on-chain
    */
}

contract Child is Base {
    /*
    Inherited contracts:
    - CANNOT access private functions or variables
    - CAN access internal functions and variables
    

    ❌ This would fail because privateFunc() is not accessible
    function testPrivateFunc() public pure returns (string memory) {
        return privateFunc();
    }
    */
    
    // ✅ Valid: internal functions are accessible in child contracts
    function testInternalFunc() public pure returns (string memory) {
        return internalFunc();
    }
}