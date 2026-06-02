// SPDX-License-Identifier: MIT
// Specifies the open-source license for this contract. Required by Solidity best practices.
pragma solidity ^0.8.26;
// Declares the Solidity compiler version. The ^ means "this version or any compatible newer patch".

/*
In this file, we will create a contract that creates other contracts

How is it useful?
- Pass fixed intputs to a new contracts
- Manage many contract from a single contract

Examples:
- Create a new contract
- Send ether and create a new contract
*/


/**
 * @title Car
 * @notice Represents a single car with an owner, model name, and its own deployed address.
 * @dev This contract is deployed by CarFactory. Its constructor is payable,
 *      allowing ETH to be sent to it at creation time.
 */
contract Car {
    address public owner;    // The Ethereum address of the car's owner
    string public model;     // The model name of the car (e.g., "Toyota", "BMW")
    address public carAddr;  // The address of this Car contract on the blockchain


    /**
     * @notice Initializes the Car with an owner and model, and records its own address.
     * @param _owner The address that will own this car A.K.A deploy the car contract).
     * @param _model The model name of this car.
     * @dev Marked payable so the factory can forward ETH to this contract on deployment.
     *      `address(this)` refers to the address of this specific Car contract instance.
     */
    constructor(address _owner, string memory _model) payable {
        owner = _owner;
        model = _model;
        carAddr = address(this); // Captures and stores this contract’s own address.
    }
}

/**
 * @title CarFactory
 * @notice A factory contract responsible for deploying and tracking Car contracts.
 * @dev Demonstrates four deployment patterns:
 *      1. Standard deployment (CREATE opcode)
 *      2. Standard deployment with ETH forwarding
 *      3. Deterministic deployment via CREATE2 (salt-based)
 *      4. Deterministic deployment via CREATE2 with ETH forwarding
 *
 *      Factory Pattern: A single contract that creates and manages many child contracts.
 *      This is useful for deploying multiple similar contracts from one place,
 *      keeping track of them, and providing a consistent interface to interact with them.
 */
contract CarFactory {
    // A dynamic array that stores references to all Car contracts deployed by this factory
    Car[] public cars;

    /**
     * @notice Deploys a new Car contract and registers it in the factory.
     * @param _owner The address that will own (deploy) the new Car contract.
     * @param _model The model name for the new Car.
     * @dev Uses the standard CREATE opcode. The deployed contract's address is
     *      determined by the factory's address and its current nonce (transaction count).
     *      Address is NOT predictable before deployment.
     */
    function create(address _owner, string memory _model) public {
        Car car = new Car(_owner, _model); // Deploy a new Car contract
        cars.push(car);                    // Register it in the factory's tracking array
    }

    /**
     * @notice Deploys a new Car contract and forwards all sent ETH to it.
     * @param _owner The address that will own (deploy) the new Car contract.
     * @param _model The model name for the new Car.
     * @dev `msg.value` is the amount of ETH (in wei) sent with this transaction.
     *      The `{value: msg.value}` syntax forwards that ETH to the Car's constructor.
     *      The Car constructor must be payable to accept ETH; which it is.
     */
    function createAndSendEther(address _owner, string memory _model)
        public
        payable
    {
        Car car = (new Car){value: msg.value}(_owner, _model); // Deploy and fund the Car
        cars.push(car);
    }

    /**
     * @notice Deploys a new Car contract at a deterministic, pre-computable address using CREATE2.
     * @param _owner The address that will own (deploy) the new Car contract.
     * @param _model The model name for the new Car.
     * @param _salt A unique bytes32 value chosen by the caller to influence the contract address.
     * @dev CREATE2 computes the deployed address from:
     *      keccak256(0xff ++ factory_address ++ salt ++ keccak256(bytecode))
     *      This means you can calculate the Car's address BEFORE deploying it,
     *      which is useful for off-chain coordination and advanced DeFi patterns
     *      like counterfactual instantiation.
     *      IMPORTANT: Using the same salt twice will cause the transaction to revert,
     *      since a contract already exists at that address.
     */
    function create2(address _owner, string memory _model, bytes32 _salt)
        public
    {
        Car car = (new Car){salt: _salt}(_owner, _model); // Deploy at a deterministic address
        cars.push(car);
    }

    /**
     * @notice Deploys a new Car at a deterministic address via CREATE2 and forwards ETH to it.
     * @param _owner The address that will own the new Car contract.
     * @param _model The model name for the new Car.
     * @param _salt A unique bytes32 value used to compute the deterministic address.
     * @dev Combines the benefits of CREATE2 (predictable address) with ETH forwarding.
     *      Both `value` and `salt` are passed using the inline options syntax: {value:..., salt:...}
     */
    function create2AndSendEther(
        address _owner,
        string memory _model,
        bytes32 _salt
    ) public payable {
        Car car = (new Car){value: msg.value, salt: _salt}(_owner, _model); // Deploy, fund, and pin address
        cars.push(car);
    }

    /**
     * @notice Retrieves all stored details for a Car at a given index.
     * @param _index The position of the Car in the `cars` array (0-based).
     * @return owner    The address of the Car's owner.
     * @return model    The model name of the Car.
     * @return carAddr  The deployed address of the Car contract.
     * @return balance  The ETH balance (in wei) held by the Car contract.
     * @dev `view` means this function only reads state — it does not modify anything
     *      and costs no gas when called externally (e.g., from a frontend or wallet).
     */
    function getCar(uint256 _index)
        public
        view
        returns (
            address owner,
            string memory model,
            address carAddr,
            uint256 balance
        )
    {
        Car car = cars[_index]; // Retrieve the Car contract reference at the given index

        // Call each public getter on the Car contract and return the ETH balance separately
        return (car.owner(), car.model(), car.carAddr(), address(car).balance);
    }


}