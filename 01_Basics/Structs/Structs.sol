// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
Structs Example:
- Create (add new todos)
- Read (retrieve todo data)
- Update (modify text or status)

This contract uses a `Todo` struct imported from another file.
*/

import "./StructDeclaration.sol";

contract Todos {

    // Dynamic array storing all Todo items
    Todo[] public todos;

    function create(string memory _text) public {
        // 3 ways to initialize a struct

        // Method 1: Positional initialization - Values must follow the exact order of struct fields,
        // so we call it like a function
        todos.push(Todo(_text, false));

        // Method 2: Named arguments (key-value style) - Order does not matter
        Todo({
            text: _text,
            completed: false
        });

        // Method 3: Initialize empty struct, then assign values
        Todo memory todo;
        todo.text = _text;
        // Note: `completed` defaults to false, so no need to assign it explicitly
    }


    // Although Solidity automatically generates a getter for public arrays,
    // this function is useful when you need to customize the returned data.

    // Read a Todo item by index. Read operation:
    // Instead of returning the entire struct, we return individual fields
    // for better control and flexibility.
    function get(uint256 _index) public view returns (string memory text, bool completed) {
        
        // Use `storage` to reference the existing struct in state
        Todo storage todo = todos[_index];

        return (todo.text, todo.completed);
    }

    // Update the text of a Todo item
    function update(uint256 _index, string memory _text) public {
        
        // Reference the stored Todo
        Todo storage todo = todos[_index];

        // Modify only the text field
        todo.text = _text;
    }

    // Toggle the completion status (true ↔ false)
    function toggleCompleted(uint256 _index) public {

        // Reference the stored Todo
        Todo storage todo = todos[_index];

        // Flip the boolean value
        todo.completed = !todo.completed;
    }

}
