// //deploy a fake price feed contract to local blockchain
// const {network} = require("hardhat")
// const {developmentChains, DECIMALS, INITIAL_ANSWER,networkConfig} = require("../helper-hardhat-config")

// module.exports = async (getNamedAccounts, deployments) => {
//     const{deploy, log} = deployments
//     const {deployer } = await getNamedAccounts()
//     const chainId = network.config.chainId

//     //if (chainId != ..) {....}
// //    if (developmentChains.includes(chainId)) {
//     if (developmentChains.includes(networkConfig.name)){ 
//         log("local network detected! Deploying mocks...")
//         await deploy("MockV3Aggregator", { 
//             contract: "MockV3Aggregator",
//             from : deployer,
//             log: true,
//             args: [DECIMALS, INITIAL_ANSWER],
//         })
//         log("Mocks deployed!")
//         log("----------------------------------------------------------------")
//     }
// }

// // run only deploy mock script
// module.exports.tags = ["all", "mocks"]

const { network } = require("hardhat")
const {
    developementChain,
    DECIMALS,
    INITIAL_ANSWER,
} = require("../helper-hardhat-config")

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId

    if (chainId == "31337") {
        log("Local network detected... deploying mocks...")
        await deploy("MockV3Aggregator", {
            contract: "MockV3Aggregator",
            from: deployer,
            log: true,
            args: [DECIMALS, INITIAL_ANSWER],
        })

        log("Mocks deployed!")
        log("-----------------------------------------------------------")
    }
}

module.exports.tags = ["all", "mocks"]