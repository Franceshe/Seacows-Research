require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config()
require("@nomiclabs/hardhat-etherscan")


/** @type import('hardhat/config').HardhatUserConfig */

const GOERLI_RPC_URL = process.env.GOERLI_RPC_URL
const PRIVATE_KEY = process.env.PRIVATE_KEY
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY

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
  },
  solidity: "0.8.8",
  etherscan:{
    apiKey: ETHERSCAN_API_KEY
  }
};
 
//https://chainlist.org/
