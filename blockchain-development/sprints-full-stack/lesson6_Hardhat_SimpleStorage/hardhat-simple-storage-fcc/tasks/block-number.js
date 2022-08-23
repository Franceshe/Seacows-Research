// get current block number of what ever current blockchain we work with
const {task} = require("hardhat/config")


task("block-number", "Prints the current block number").setAction(
    // javascript error function
    // anominous function

    // const blockTask = async function() => {}
    // async function blockTask(){

    //hre: hardhart runtime environment
    async (taskArgs, hre) => {
         const blockNumber = await hre.ethers.provider.getBlockNumber()
         console.log(`current blockNumber is : ${blockNumber}` )

    }
    )

module.exports ={}