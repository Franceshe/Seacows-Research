// import 
// main func
// calling of man func

// function deployFunc(hre){
//     console.log("Hi!")
//     hre.getNamedAccounts()
//     hre.deployments()
// }

// module.exports.default = deployFunc

//  module.exports = async (hre) => {
//     const{getNamedAccounts, deployments} = hre
module.exports = async (getNamedAccounts, deployments) => {
    const{deploy, log} = deployments
    const {deployer } = await getNamedAccounts()
    const chainId = network.config.chainId
}
    // hre.getNamedAccounts
    // hre.deployments

    // if chainId is X use address Y
    // if chainId is Z use address A
    const ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]
    
    // if the contract dosen't exits  


    // Learn from github: https://github.com/aave/aave-v3-core-? helper-hardhat-config
    const {networkConfig} = require("../helper-hardhat-config")
    //equivalent to
    //const helperConfig = require("../helper-hardhat-config")
    // const networkConfig = helperConfig.networkConfig

    // well what happens when we want to change chains
    // when going for localhost or hardhat network we want to use a mock
    //const address = "0x8A753747A1Fa494EC906cE90E9f37563A8AF630e";
    const fundMe = await deploy("FundMe",{
        from: deployer,
        args: [], // put price feed address
        log: true, 

    })

