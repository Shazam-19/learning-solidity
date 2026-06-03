// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

    // Enum representing the lifecycle of a user account
    enum accountStatus {
        Inactive,  // 0 → Account created but not yet activated
        Active,    // 1 → Account is active and usable
        Suspended, // 2 → Account temporarily restricted
        Banned     // 3 → Account permanently blocked
    }