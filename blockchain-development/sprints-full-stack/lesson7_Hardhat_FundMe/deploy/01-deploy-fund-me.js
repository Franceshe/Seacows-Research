// // import 
// // main func
// // calling of man func

// // function deployFunc(hre){
// //     console.log("Hi!")
// //     hre.getNamedAccounts()
// //     hre.deployments()
// // }

// // module.exports.default = deployFunc

// const {network} = require("hardhat")
// const {networkConfig} = require("../helper-hardhat-config")
// //equivalent to
// //const helperConfig = require("../helper-hardhat-config")
// // const networkConfig = helperConfig.networkConfig

// //  module.exports = async (hre) => {
// //     const{getNamedAccounts, deployments} = hre
// module.exports = async (getNamedAccounts, deployments) => {
//     const{deploy, log} = deployments
//     const {deployer } = await getNamedAccounts()
//     const chainId = network.config.chainId
// }
//     // hre.getNamedAccounts
//     // hre.deployments

//     // if chainId is X use address Y
//     // if chainId is Z use address A
//     //const ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]
//     let ethUsdPriceFeedAddress
//     if(developmentChains.includes(network.name)){
//         const ethUsdPriceFeedAddress = await get("MockV3Aggregator")
//     }
    
//     // if the contract dosen't exits, we deploy a minial version of
//     // for our local testing


//     // Learn from github: https://github.com/aave/aave-v3-core-? helper-hardhat-config


//     // well what happens when we want to change chains
//     // when going for localhost or hardhat network we want to use a mock
//     //const address = "0x8A753747A1Fa494EC906cE90E9f37563A8AF630e";
//     const fundMe = await deploy("FundMe",{
//         from: deployer,
//         args: [ethUsdPriceFeedAddress], // put price feed address
//         log: true, 

//     })
/*++++++++++++++++++++++++++++++++*/

// const { network } = require("hardhat")

// const { networkConfig } = require("../helper-hardhat-config")
// const {
//     developmentChains,
//     DECIMALS,
//     INITIAL_ANSWER,
// } = require("../helper-hardhat-config")
// const {verify} = require("../utils/verify")
// //      (or)
// // const helperConfig = require("../helper-hardhat-config")
// // const networkConfig = helperConfig.networkConfig

// module.exports = async ({ getNamedAccounts, deployments }) => {
//     const { deploy, log } = deployments
//     const { deployer } = await getNamedAccounts()
//     const chainId = network.config.chainId

// //const ethUSDPriceFeedAddress = networkConfig[chainId]["ethUSDPriceFeed"]
//     let ethUsdPriceFeedAddress
    
//     if(developmentChains.includes(network.name)){
//         //const ethUsdPriceFeedAddress = await deployments.get("MockV3Aggregator")
//         const ethUsdAggregator = await deployments.get("MockV3Aggregator")
//         ethUsdPriceFeedAddress = ethUsdAggregator.address
//     }else{
//         ethUsdPriceFeedAddress = networkConfig[chainId]["ethUSDPriceFeed"]
//     }
 
// const args = [ethUsdPriceFeedAddress]    
// const fundMe = await deploy("FundMe", {
//     from: deployer,
//     args: args, //put price feed address.
//     log: true,
// })

// //
// if (!developmentChains.includes(network.name) 
// && process.env.ETHERSCAN_API_KEY){
//     // verify()
//     await verify(fundMe.address, args)
// }


// log("-------------------------------")

// }

// module.exports.tags = ["all", "FundMe"]

const { getNamedAccounts, deployments, network } = require("hardhat")
const { networkConfig, developmentChains } = require("../helper-hardhat-config")
const { verify } = require("../utils/verify")

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId

    let ethUsdPriceFeedAddress
    if (chainId == 31337) {
        const ethUsdAggregator = await deployments.get("MockV3Aggregator")
        ethUsdPriceFeedAddress = ethUsdAggregator.address
    } else {
        ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]
    }
    log("----------------------------------------------------")
    log("Deploying FundMe and waiting for confirmations...")
    const fundMe = await deploy("FundMe", {
        from: deployer,
        args: [ethUsdPriceFeedAddress],
        log: true,
        // we need to wait if on a live network so we can verify properly
        waitConfirmations: network.config.blockConfirmations || 1,
    })
    log(`FundMe deployed at ${fundMe.address}`)

    if (
        !developmentChains.includes(network.name) &&
        process.env.ETHERSCAN_API_KEY
    ) {
        await verify(fundMe.address, [ethUsdPriceFeedAddress])
    }
}

module.exports.tags = ["all", "fundme"]