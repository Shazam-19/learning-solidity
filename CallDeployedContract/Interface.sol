// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// How to interact with deployed contract?
// Interface
// Uniswap example

interface ICounter {
    function count() external view returns (uint256);
    function increment() external;
}

contract MyContract {
    function incrementCounter(address _counter) external {
        ICounter(_counter).increment();
    }

    function getCounter(address _counter) external view returns (uint256) {
        return ICounter(_counter).count();
    }
}