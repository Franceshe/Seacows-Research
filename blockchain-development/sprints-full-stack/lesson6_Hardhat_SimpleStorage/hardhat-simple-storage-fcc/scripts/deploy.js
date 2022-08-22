// imports
//const {ethers} = require('ethers');
// run allows us to run any hardhat tasks
const {ethers, run} = require("hardhat")



// async main 
async function main(){
  const SimpleStorageFactory = await ethers.getContractFactory("SimpleStorage")
  console.log("Deploying contract");
  const simpleStorage = await SimpleStorageFactory.deploy()
  await simpleStorage.deployed()
  // what's the private key?
  // what's the rpc url?
  console.log(`Deployed contract to ${simpleStorage.address}`)
  //Deployed contract to 0x5FbDB2315678afecb367f032d93F642f64180aa3

}

  //automatic verify
async function verify(contractAddress, args){
  // works on etherscan -> or do it with explore api
  // verify contract programmatically
  // hardhat plugin! hardhat-etherscan plugin :)
  console.log("Verifying contract...")
  await run("verify:verify", {
    address: contractAddress,
    constructorArgs: args,
  })


}

// main
main().then(() => process.exit(0)).catch((error) =>{
  console.error(error);
  process.exit(1);
});

// Network in hardhart
//Deployed contract to 0x6CbFa96BB49c48428356d0d4366B6e3Bf74e2fAf
// Prgamatic verification
//`yarn add --dev @nomiclabs/hardhat-etherscan `
// added: verify   Verifies contract on Etherscan 