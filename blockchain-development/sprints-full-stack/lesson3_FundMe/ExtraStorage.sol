// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "./SimpleStorage.sol";

// !Inheritance and Override
//Get ExtraStorage contract inherts all funcs of SimpleStorage.sol
// ExtraStorage.sol is a child contract of SS.sol

    // + 5 to favorite number
    // override
    // Virtual override
    // see how similar it is to C++

contract ExtraStorage is SimpleStorage {
    function store(uint256 _favoriteNumber) public override {
        favoriteNumber = _favoriteNumber + 5;
    }
}


