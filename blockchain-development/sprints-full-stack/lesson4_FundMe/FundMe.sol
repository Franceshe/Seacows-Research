//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;


//import directly from github or npm
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";



// Sending ETH Through a function & Reverts.

//Get funds from users
//Withdraw funds
//Set a mininum funding value of USD

//using chainlink pricefeed
// Learn chainlink and oracles


//Chailink aggregatorV3 Interface


contract FundMe {

    /*uint256 public number;*/

    uint256 public minimumUsd = 50 * 1e18 ; // 1 * 10 ** 18 

    // when people send all the money to this contract
    // we'd love to track all the people who sent us money
    address[] public funders;

    // a maaping for people - how much they sent
    mapping(address => uint256) public addressToAmountFunded;

    function fund() public payable {
        //want to be able to set a minum fund amount in usd
        //1. How do we send ETH to this contract

        /*number = 5;            */
        //keyword to access msg
        /*require(msg.value > 1e18, "Didn't send enough! " ); // 1e18 = 1 * 10 **18 = 1000000000000000000 */

        //Library: msg.value.getConversionRate();
        require(getConversionRate(msg.value) >= minimumUsd, "Didn't send enough!"); 
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
            // get price eth interms of usd
        function getPrice() public view returns(uint256) {
            // an instance of contract which need to interact with outside data
            // we need two things
            // 1. ABI How to get ABI? => Interface!
            // 2. Address of contract: 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
            // Testnet network: Georli
            // ETH/USD contract: 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
            AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
            //(uint80 roundId, int price, uint startedAt, uint timeStamp, uint80 answeredInRound ) =  priceFeed.latestRoundData();    
            (,int256 price,,, ) =  priceFeed.latestRoundData();   
            // ETH interms of USD
            // 1800.00000000  -> 1e8
            //price is int256 or int instead of uint since sometimes pricefeeds could be negative
            return uint256(price * 1e10); // 1**10 = 10000000000, to get price match up

            //type casting, convert int256->uint256

        }

        //Interface
        //for this func, we need a real testnet to work with oracles
        function getVersion() public view returns (uint256){
            AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
            return priceFeed.version();

        }



        function getConversionRate(uint256 ethAmount) public view returns (uint256){
            uint256 ethPrice = getPrice();
            // 1800_000000000000000000(18 0's) = ETH / USD price
            //    1_000000000000000000 ETH
              
            uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
             
            //NOTE: always multiple before you divide
            return ethAmountInUsd;

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


// INTERFACE && PRICEFEED
// FLOATING POINT MATH IN SOLIDITY 
// BASIC Solidity: Arrays && Structs II
// Review Interfaces, Github imports, &Math in solidity
// Concept of Library: https://solidity-by-example.org/library/

// Reference:
/*
1. https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol
2. https://solidity-by-example.org/library/


*/