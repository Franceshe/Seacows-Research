// SPDX_License-Identitfier: MIT
pragma solidity ^0.8.0;

contract SafeMathTester{

    uint8 public bigNumber = 255; // before ^0.8.0, the number "unchecked"

    function add() public{
        bigNumber = bigNumber + 1;
        // unchecked {bigNumber = bigNumber + 1;}
        // why use this "unchecked " keyword: more gas effcient

    }
    // you reach the max the number can be, and the transaction gonna fail 

}