//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;


// Sending ETH Through a function & Reverts.

//Get funds from users
//Withdraw funds
//Set a mininum funding value of USD

//using chainlink pricefeed
// Learn chainlink and oracles


//Chailink aggregatorV3 Interface
interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  function getRoundData(uint80 _roundId)
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
}






contract FundMe {

    /*uint256 public number;*/

    uint256 public minimumUsd = 50;

    function fund() public payable {
        //want to be able to set a minum fund amount in usd
        //1. How do we send ETH to this contract

        /*number = 5;            */
        //keyword to access msg
        /*require(msg.value > 1e18, "Didn't send enough! " ); // 1e18 = 1 * 10 **18 = 1000000000000000000 */
        require(msg.value >= minimumUsd, "Didn't send enough!"); 
        //require as checker, otherwise raise error
     
        // What is reverting?
        // undo any action happen before, and send remaining gas back
        // a ton of computation here, ig here number = 5 reverted to number = 0


        //msg.values interms of ethereum, need to be converted, chainlink-> oracle
        //https://api -> won't reach concensus for nodes of blockchain
        //Chainlink Data feeds  

        

    }
            // get price eth interms of usd
        function getPrice() public {
            // an instance of contract which need to interact with outside data
            // we need two things
            // 1. ABI How to get ABI? => Interface!
            // 2. Address of contract: 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
            // Testnet network: Georli
            // ETH/USD contract: 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e

        }

        //Interface
        //for this func, we need a real testnet to work with oracles
        function getVersion() public view returns (uint256){
            AggregatorV3Interface pricefeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
            return pricefeed.version();

        }



        function getConversionRate() public {}

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


// Reference:
/*
1. https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol


*/