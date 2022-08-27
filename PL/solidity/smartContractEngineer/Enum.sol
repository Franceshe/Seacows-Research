// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


// Enum helps represent choices
// In which enumerables and they are useful to model choice and to keep track of state.
contract EnumExamples {
    // Enum representing shipping status
    enum Status {
        // No shipping request
        None,
        Pending,
        Shipped,
        // Accepted by receiver
        Completed,
        // Rejected by receiver (damaged, wrong item, etc...)
        Rejected,
        // Canceled before shipped
        Canceled
    }

    Status public status;

    //or use it in a struct
    // combine enum with other data types
    struct Order{
        address buyer;
        Status status;
    }
    
    // a array of orders
    //Orders[] public orders;
    
    // Returns uint
    // None      - 0
    // Pending   - 1
    // Shipped   - 2
    // Completed - 3
    // Rejected  - 4
    // Canceled  - 5
    
    //function output: enum
    function get() external view returns (Status) {
        return status;
    }

    // Update
    function set(Status _status) external {
        status = _status;
    }

    //update a enum to a spefic enum
    function ship() external{
        status = Status.Shipped;
    }

    // Update to a specific enum
    function cancel() external {
        status = Status.Canceled;
    }

    // Reset enum to it's default value, 0
    function reset() external  {
        delete status;
    }
}
