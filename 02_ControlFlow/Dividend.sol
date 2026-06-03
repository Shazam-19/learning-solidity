// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Dividend {
    // Fixed-size array to store up to 100 shareholder addresses.
    // Each address represents a user who may receive Ether payments (dividends).
    // Anyone can view the list from outside the contract
    // If an address is empty AKA address(0), it will still count as a loop
    address[100] public shareholders; 


    // This function is intended to distribute Ether to all shareholders.
    // NOTE: In real-world contracts, sending Ether inside loops can be risky
    // due to gas limits and potential transaction failures.
    function pay() public {

        // Calculate equal share for each shareholder
        // NOTE: Integer division may leave a small remainder in the contract
        uint256 amountPerShareholder = address(this).balance / shareholders.length;

        // 🔁 Loop through all shareholders in the array
        // `shareholders.length` is always 100 because this is a fixed-size array
        for (uint256 i = 0; i < shareholders.length; i++) {

            address shareholder = shareholders[i];

            // Skip empty addresses (not initialized)
            if (shareholder == address(0)) {
                continue;
            }

            // Convert address to payable and send Ether
            payable(shareholder).transfer(amountPerShareholder);

            // ⚠️ Important considerations (not implemented here):
            // - Ensure contract has enough balance
            // - Handle failures when sending Ether
        }
    }

    // Allow the contract to receive Ether
    receive() external payable {}
}

