// in nodejs
// require() keyword to import dependency

// in front end javascript you can't use require
// import
const {ethers} = require("ethers")

async function connect() {
    if (typeof window.ethereum != "undefined") {
        await window.ethereum.request({ method: "eth_requestAccounts" })
        document.getElementById("connectButton").innerHTML = "Connected!"
        //console.log("connected!")
    } else {
        ///console.log("No metamask")
        document.getElementById("connectButton").innerHTML = "Please install metamask!"
    }
} 


async function fund(ethAmount){
    console.log(`Funding with ${ethAmount}...`)
    if(typeof window.ethereum != "undefined"){
        //provider / connection to the blockchain
        //signer /wallet / someone with some gas to sent it
        // contract that we are interacting with
        // ^ ABI & address

    }
}
// fund functiona



// withdraw function