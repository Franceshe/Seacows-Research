const {run} = require("hardhat")

//automatic verify
// won't work on thihs verify func with local(hardhat) network 
//async function verify(contractAddress, args){  => which is equivalent to the following line: function being varible
const verify = async (contractAddress, args) => {
    // works on etherscan -> or do it with explore api
    // verify contract programmatically
    // hardhat plugin! hardhat-etherscan plugin :)
    console.log("Verifying contract...")
    // if contract already being verifyed
    try {
      await run("verify:verify", {
        address: contractAddress,
        constructorArguments: args,
      })
    } catch (e) {
      if (e.message.toLowerCase().includes("already verified")) {
        console.log("Already Verified")
      }
      else {
        console.log(e)
      }
    }
  
  }

  module.exports = {verify}