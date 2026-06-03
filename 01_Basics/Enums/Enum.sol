// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./EnumDeclaration.sol"; // Here we import the other file enum accountStatus

contract Order {

    // Enum representing the lifecycle of an order
    // Enums are internally represented as uint values starting from 0

    enum Status {
        Pending,  // 0 → Order created, not yet processed
        Shipped,  // 1 → Order has been shipped
        Accepted, // 2 → Delivery confirmed by recipient
        Rejected, // 3 → Delivery declined by recipient
        Canceled  // 4 → Order canceled before shipping
    }

    // Current order status
    // Defaults to the first enum value → Pending
    Status public status;

    // Current account status
    // Defaults to the first enum value → Inactive
    accountStatus public accStat; 

    // Mark the order as shipped
    function ship() public {

        // Only allow shipping if order is still pending
        require(status == Status.Pending);

        status = Status.Shipped;
    }

    // Accept the delivered order
    function acceptDelivery() public {
        // Only allow acceptance if order has been shipped
        require(status == Status.Shipped);

        status = Status.Accepted;
    }

    // Reject the delivered order
    function rejectDelivery() public {
        // Only allow rejection if order has been shipped
        require(status == Status.Shipped);

        status = Status.Rejected;
    }

    // Cancel the order before it is shipped
    function cancel() public {
        // Only allow cancellation if order is still pending
        require(status == Status.Pending);

        status = Status.Canceled;
    }
}