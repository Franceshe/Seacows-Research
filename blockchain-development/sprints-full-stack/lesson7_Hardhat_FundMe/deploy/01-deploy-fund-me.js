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
}
    // hre.getNamedAccounts
    // hre.deployments
 }