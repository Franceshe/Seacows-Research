// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleStorage.sol"; 

// contract interact with other contracts
// Composobility



contract StorageFactory{

    //SimpleStorage public simpleStorage;        // type visibility name
    SimpleStorage[] public simpleStorageArray; //

    function createSimpleStorageContract() public{
        // How does storage factory know what simple storage contract look like?
        //simpleStorage = new SimpleStorage(); 

        // save it as memory variable?
        SimpleStorage simpleStorage = new SimpleStorage(); 
        simpleStorageArray.push(simpleStorage);
    }
}