//SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
 
// A library to attach uint256


// Library can't have state variables and can't send either
// all functions need to be internal
library PriceConverter{


        function getPrice() internal view returns(uint256) {
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
        function getVersion() internal view returns (uint256){
            AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
            return priceFeed.version();

        }



        function getConversionRate(uint256 ethAmount) internal view returns (uint256){
            uint256 ethPrice = getPrice();
            // 1800_000000000000000000(18 0's) = ETH / USD price
            //    1_000000000000000000 ETH
              
            uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
             
            //NOTE: always multiple before you divide
            return ethAmountInUsd;

        }

}