// imports
//const {ethers} = require('ethers');
// run allows us to run any hardhat tasks
const {ethers, run, network} = require("hardhat")



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

  // what happends when we deploy to our hardhat network?
  // check network config
  //console.log(network.config)

  // verify on Testnet on georli
  if(network.config.chainId === 5 && process.env.ETHERSCAN_API_KEY){
    console.log("Waiting for block txes...")
    // give some time for etherscan to include it in block
    await simpleStorage.deployTransaction.wait(6);
    await verify(simpleStorage.address, [])
  }

  // interact with the contract
  const currentValue = await simpleStorage.retrieve()
  console.log(`Current value is: ${currentValue}`)

  // Update the curent value
  const transactionResponse = await simpleStorage.store(7)
  await transactionResponse.wait(1)
  const updatedValue = await simpleStorage.retrieve()
  console.log(`Updated Value is :${updatedValue}`)

}

  //automatic verify
  // won't work on thihs verify func with local(hardhat) network 
 //async function verify(contractAddress, args){  => which is equivalent to the following line: function being varible
const verify = async(contractAddress, args) => {  
  // works on etherscan -> or do it with explore api
  // verify contract programmatically
  // hardhat plugin! hardhat-etherscan plugin :)
  console.log("Verifying contract...")
  // if contract already being verifyed
  try{
  await run("verify:verify", {
    address: contractAddress,
    constructorArguments: args,
  })
  }catch (e){
    if(e.message.toLowerCase().includes("already verified")){
      console.log("Already Verified")
    }
    else{
      console.log(e)
    }
  }
  
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
// Interacting with contracts in hardhart