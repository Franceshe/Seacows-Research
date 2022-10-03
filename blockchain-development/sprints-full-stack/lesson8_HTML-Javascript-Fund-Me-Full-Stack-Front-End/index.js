// in nodejs
// require() keyword to import dependency

// in front end javascript you can't use require
// import
//const {ethers} = require("ethers")
import { ethers } from "./ethers-5.6.esm.min.js"
//import { abi, contractAddress } from "./constants.js"
import { abi, contractAddress } from "./constants.js"

const connectButton = document.getElementById("connectButton")
const fundButton = document.getElementById("fundButton")
connectButton.onclick = connect
fundButton.onclick = fund

//console.log(ethers)

// async function connect() {
//   if (typeof window.ethereum !== "undefined") {
//     try {
//       await window.ethereum.request({ method: "eth_requestAccounts" })
//     } catch (error) {
//       console.log(error)
//     }
//     connectButton.innerHTML = "connected"
//   } else {
//     connectButton.innerHTML = "Please install Metamask"
//   }
// }

async function connect() {
  if (typeof window.ethereum !== "undefined") {
    try {
      await ethereum.request({ method: "eth_requestAccounts" })
    } catch (error) {
      console.log(error)
    }
    connectButton.innerHTML = "Connected"
    const accounts = await ethereum.request({ method: "eth_accounts" })
    console.log(accounts)
  } else {
    connectButton.innerHTML = "Please install MetaMask"
  }
}

async function fund() {
  const ethAmount = "77"
  console.log(`Funding with ${ethAmount}...`)
  if (typeof window.ethereum !== "undefined") {
    //provider / connection to the blockchain
    //signer /wallet / someone with some gas to sent it
    // contract that we are interacting with
    // ^ ABI & address
    const provider = new ethers.providers.Web3Provider(window.ethereum)
    const signer = provider.getSigner()
    const contract = new ethers.Contract(contractAddress, abi, signer)
    const transactionResponse = await contract.fund({
      value: ethers.utils.parseEther(ethAmount),
    })

    //console.log(signer)
  }
}
// fund functiona

// withdraw function
