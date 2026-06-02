// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title ICounter
 * @notice Interface for interacting with a deployed Counter contract.
 * @dev An interface defines the external functions that another contract exposes.
 *      It allows this contract to call functions on an already deployed contract
 *      without needing its full source code.
 */
interface ICounter {
    /**
     * @notice Returns the current counter value.
     * @return The current count stored in the Counter contract.
     */
    function count() external view returns (uint256);

    /**
     * @notice Increases the counter value by one.
     */
    function increment() external;
}

/**
 * @title MyContract
 * @notice Demonstrates how to interact with a deployed contract using an interface.
 * @dev The contract receives the address of a deployed Counter contract and
 *      uses the ICounter interface to call its functions.
 */
contract MyContract {
    /**
     * @notice Calls the increment function on a deployed Counter contract.
     * @param _counter Address of the deployed Counter contract.
     * @dev The address is cast to the ICounter interface, allowing this
     *      contract to call the external increment() function.
     */
    function incrementCounter(address _counter) external {
        ICounter(_counter).increment();
    }

    /**
     * @notice Retrieves the current counter value from a deployed Counter contract.
     * @param _counter Address of the deployed Counter contract.
     * @return The current counter value.
     * @dev Calls the count() view function through the ICounter interface.
     */
    function getCounter(address _counter) external view returns (uint256) {
        return ICounter(_counter).count();
    }
}