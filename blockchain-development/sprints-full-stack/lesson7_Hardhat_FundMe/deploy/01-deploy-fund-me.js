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

    // well what happens when we want to change chains
    // when going for localhost or hardhat network we want to use a mock


