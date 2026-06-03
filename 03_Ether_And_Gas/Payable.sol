// SPDX-License-Identifier: MIT
pragma solidity ^0.5.12;

/*
Payable Example:
- Receiving Ether (payable functions)
- Sending Ether (transfer)
- Using payable addresses
- Emitting events for tracking transactions

Note:
Events are essential when building a UI, as they allow off-chain
applications to listen for contract activity in real time.
*/

contract Payable {

    // Emitted when Ether is deposited into the contract
    event Deposit(address sender, uint256 amount, uint256 balance);

    // Emitted when Ether is withdrawn by the owner
    event Withdraw(uint256 amount, uint256 balance);

    // Emitted when Ether is transferred to another address
    event Transfer(address to, uint256 amount, uint256 balance);

    // Owner of the contract (can receive Ether by using the 'payable' keyword)
    address payable public owner;

    // Constructor is payable → allows sending Ether during deployment
    constructor() public payable {
        
        // Set the deployer as the owner
        owner = msg.sender;

    }

    // Deposit Ether into the contract
    // Must be called with msg.value > 0
    // The balance of this contract will be automatically updated.
    function deposit() public payable {

        // Emit event to log deposit details
        emit Deposit(msg.sender, msg.value, address(this).balance);

    }


    // Non-payable function
    // Sending Ether to this function will cause the transaction to revert
    function notPayable() public {}

    // Modifier to restrict access to the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not Owner");
        _;
    }

    // Withdraw Ether from the contract to the owner
    function withdraw(uint256 _amount) public onlyOwner {

        // Transfer Ether to owner
        // Reverts automatically if balance is insufficient
        owner.transfer(_amount);

        // Emit event after withdrawal
        emit Withdraw(_amount, address(this).balance);

    }

    // Transfer Ether from this contract to another address
    function transfer(address payable _to, uint256 _amount) public onlyOwner {

        // `_to` must be payable to receive Ether
        _to.transfer(_amount); // Built-in function available only for payable addresses by Solidity

        // Emit event after transfer
        emit Transfer(_to, _amount, address(this).balance);
    }

    // Returns the current Ether balance of this contract
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}