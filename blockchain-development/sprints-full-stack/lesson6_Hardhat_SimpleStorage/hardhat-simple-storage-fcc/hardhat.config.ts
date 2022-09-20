require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config()
require("@nomiclabs/hardhat-etherscan")
require("./tasks/block-number")
require("hardhat-gas-reporter")
require("solidity-coverage")

/** @type import('hardhat/config').HardhatUserConfig */

const GOERLI_RPC_URL = process.env.GOERLI_RPC_URL   
const PRIVATE_KEY = process.env.PRIVATE_KEY
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY
const COINMARKETCAP_API_KEY = process.env.COINMARKETCAP_API_KEY

// const GOERLI_RPC_URL = process.env.GOERLI_RPC_URL || "https://eth-goerli"
// const PRIVATE_KEY = process.env.PRIVATE_KEY || "0xkey"
// const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY || "key"
// const COINMARKETCAP_API_KEY = process.env.COINMARKETCAP_API_KEY || "key"

module.exports = {
  //defaultNetwork: "hardhat": with automative private key and rpc url
  // better be specific 
  defaultNetwork: "hardhat",
  networks: {
    goerli:{
      url: GOERLI_RPC_URL, 
      accounts: [PRIVATE_KEY], 
      chainId: 5,
    },
    localhost:{
      url: "http://127.0.0.1:8545/",
      //accounts: thankds hardhat! 
      chainId: 31337,
    }
  },
  solidity: "0.8.8", 
  etherscan:{
    apiKey: ETHERSCAN_API_KEY
  },
  gasReporter:{
    enabled: false, 
    outputFile: "gas-report.txt",
    noColors: true,
    currency: "USD",
    coinMarketcap:COINMARKETCAP_API_KEY,
    token: "MATIC",
  }

};
  
//https://chainlist.org/
