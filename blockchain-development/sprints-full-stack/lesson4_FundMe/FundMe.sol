//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;


//import directly from github or npm
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";


// Sending ETH Through a function & Reverts.

//Get funds from users
//Withdraw funds
//Set a mininum funding value of USD

//using chainlink pricefeed
// Learn chainlink and oracles


//Chailink aggregatorV3 Interface


contract FundMe {

    using PriceConverter for uint256;  
    
    /*uint256 public number;*/

    uint256 public minimumUsd = 50 * 1e18 ; // 1 * 10 ** 18 

    // when people send all the money to this contract
    // we'd love to track all the people who sent us money
    address[] public funders;

    // a maaping for people - how much they sent
    mapping(address => uint256) public addressToAmountFunded;

    //only the ownder of the contract can call withdraw()
    //set the owner
    address public owner;

   constructor(){
       owner = msg.sender;
   }
    
    function fund() public payable {
        //want to be able to set a minum fund amount in usd
        //1. How do we send ETH to this contract

        /*number = 5;            */
        //keyword to access msg
        /*require(msg.value > 1e18, "Didn't send enough! " ); // 1e18 = 1 * 10 **18 = 1000000000000000000 */

        //Library: msg.value.getConversionRate();
        require(msg.value.getConversionRate() >= minimumUsd, "Didn't send enough!"); 
        //require(getConversionRate(msg.value) >= minimumUsd, "Didn't send enough!"); 
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
        //require as checker, otherwise raise error
     
        // What is reverting?
        // undo any action happen before, and send remaining gas back
        // a ton of computation here, ig here number = 5 reverted to number = 0


        //msg.values interms of ethereum, need to be converted, chainlink-> oracle
        //https://api -> won't reach concensus for nodes of blockchain
        //Chainlink Data feeds  

        //msg.value got 18 decimal places, 1ETHER = 10**18 WEIm
        //msg.value is uint256, keyword for how much eth/or native blockchain currency is sent
        //msg.sender is the address who call the fund() function

    

    }

    //withdraw the amount funded to the contract
    //need to reset funders[] and addressToAmountFunded;

    function withdraw() public onlyOwner{
        //required the owner to be able to call withdraw()
        //require(msg.sender == owner, "Sender is not owner");
        // we can use function modifier to reduce redundant work

        // Concept: for loop
        for(uint256 founderIndex = 0; founderIndex < funders.length; founderIndex++){
            address funder = funders[founderIndex];
            addressToAmountFunded[funder] = 0;

        }

        //reset the array
        //Solidity: resetting array
        funders = new address[](0);

        //actully withdraw the funds

        //Sending eth from contract
        //There are three ways to do it
        /*
        1.transfer
        2.send
        3.call
        */

        //1.transfer(_, throws an error)
        //msg.sender = address
        //payable(msg.sender) = address, here we use type casting
        // this refers to the contract
        /*payable(msg.sender).transfer(address(this).balance);*/

        //2.send(_, bool)
        /*bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "Send failed");*/
 
        // 3. call: **
        //(bool callsuccess, bytes memory dataReturned) = payable(msg.sender).call{value: address(this).balance}("");
        // since we don't care about dat aReturned, ignore it
        (bool callsuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callsuccess, "Call failed");

        //here call is the recommended method, although for most part
        //It can be case-by-case
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Sender is not ownder!");
        _; // call rest of the code

    }

//    function withdraw(){}
}


/* Transaction - Fields:
* Nonce: Tx count for the account
* Gas price: price per unit of gas(in wei)
* Gas limit: max gas that this tx can use, eg:21000
* To: address that the tx is sent to
* Value: amount of wei to send
* Data: What to send to the To address
* v,r,s: components of tx signture 
 
// Eth unit converter: eth-converter.com
*/

// Smart contract can hold funds just like how wallets can


/*Topics covered:*/
// INTERFACE && PRICEFEED
// FLOATING POINT MATH IN SOLIDITY 
// BASIC Solidity: Arrays && Structs II
// Review Interfaces, Github imports, &Math in solidity
// Concept of Library: https://solidity-by-example.org/library/
// SafeMath, Overflow, Checking, and the "unchecked" keyword
// Solidity for loops
// Sending either: transfer/send/call
// Constructor
// Basic solidity modifier


// Reference:
/*
1. https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol
2. https://solidity-by-example.org/library/


*/

//testing for wei
//for current eth price:$1800
// 50/1800 +=0.027ETH
// 0.027ETH = 27000000000000000 Wei
