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

async function getBalance() {
  if (typeof window.ethereum !== "undefined") {
    const provider = new ethers.providers.Web3Provider(window.ethereum)
    const balance = await provider.getBalance(contractAddress)
    console.log(ethers.utils.formatEther(balance))
  }
}

async function fund() {
  //const ethAmount = "0.1"

  const ethAmount = document.getElementById("ethAmount").value
  console.log(`Funding with ${ethAmount}...`)
  if (typeof window.ethereum !== "undefined") {
    //provider / connection to the blockchain
    //signer /wallet / someone with some gas to sent it
    // contract that we are interacting with
    // ^ ABI & address
    const provider = new ethers.providers.Web3Provider(window.ethereum)
    const signer = provider.getSigner()
    const contract = new ethers.Contract(contractAddress, abi, signer)
    try {
      const transactionResponse = await contract.fund({
        value: ethers.utils.parseEther(ethAmount),
      })
      // hey, wait for this TX to finish
      await listenForTransactionMine(transactionResponse, provider)
      console.log("Done")
      // listen for the tx to be mined
      // listened for the event <- we haven't learned about the event yet?
    } catch (error) {
      console.log(error)
    }

    //console.log(signer)
  }
}

function listenForTransactionMine(transactionResponse, provider) {
  console.log(`Mining ${transactionResponse.hash}...`)
  //return new Promise()
  // create a listener for the blockchain
  // listen for this transaction to finish
  //provider.once(eventName, listener) -> etherjs docs

  // we want to wait the following whole thing to finish
  // thus create a promis -> event loop
  return new Promise((resolve, reject) => {
    provider.once(transactionResponse.hash, (transactionReceipt) => {
      console.log(
        `Completed with ${transactionReceipt.confirmations} confirmations `
      )
      resolve()
    })
    //() => {} represent anonymous function
  })
}

// fund functiona

// withdraw function
