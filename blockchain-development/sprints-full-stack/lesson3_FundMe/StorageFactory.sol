// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./SimpleStorage.sol"; 

// contract interact with other contracts
// Composobility


contract StorageFactory{

    //SimpleStorage public simpleStorage;        // type visibility name
    SimpleStorage[] public simpleStorageArray; //

    //create SimpleStorage Contract
    function createSimpleStorageContract() public{
        // How does storage factory know what simple storage contract look like?
        //simpleStorage = new SimpleStorage(); 

        // save it as memory variable? 
        SimpleStorage simpleStorage = new SimpleStorage(); 
        simpleStorageArray.push(simpleStorage);
    }

    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {
        // In order to interact with a contract, you need
        // Address
        // ABI(Application Bianry Interface) of contract
        // HERE we automatally get the ABI by importing ".sol"

 //        SimpleStorage simpleStorage = SimpleStorage(simpleStorageArray[_simpleStorageIndex]);
 //        simpleStorage.store(_simpleStorageNumber);
        SimpleStorage(simpleStorageArray[_simpleStorageIndex]).store(_simpleStorageNumber);

    }

    function sfGet(uint256 _simpleStorageIndex) public view returns(uint256){
//        SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIndex];
//        return simpleStorage.retrieve();
        return simpleStorageArray[_simpleStorageIndex].retrieve();
    }
    
}