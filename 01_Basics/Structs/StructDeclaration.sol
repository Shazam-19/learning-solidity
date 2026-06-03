// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;


// Represents a single task in a to-do list
struct Todo {
    string text;      // Description of the task
    bool completed;   // Status: true = done, false = not done
}
