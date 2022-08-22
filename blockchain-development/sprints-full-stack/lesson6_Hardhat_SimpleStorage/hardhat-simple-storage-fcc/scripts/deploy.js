// imports
//const {ethers} = require('ethers');
const {ethers} = require("hardhat")


// async main 
async function main(){
  const SimpleStorageFactory = await ethers.getContractFactory("SimpleStorage")
  console.log("Deploying contract");
  const simpleStorage = await SimpleStorageFactory.deploy()
  await simpleStorage.deployed()
  // what's the private key?
  // what's the rpc url?
  console.log(`Deployed contract to ${simpleStorage.address}`)
}

// main
main().then(() => process.exit(0)).catch((error) =>{
  console.error(error);
  process.exit(1);
});
