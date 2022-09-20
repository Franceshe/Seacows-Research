const {ethers} = require('hardhat')
const {expect, assert} = require('chai')
function testFunc(){


}

// best practice
describe("SimpleStorage", function(){
  //let simpleStorageFactory,
  //let simpleStorage,
  let simpleStorageFactory, simpleStorage

  beforeEach(async function(){
    simpleStorageFactory = await ethers.getContractFactory("SimpleStorage")
    simpleStorage = await simpleStorageFactory.deploy()
  })

  it("Should start with  favorite number of 0", async function(){
    const currentValue = await simpleStorage.retrieve()
    const expectedValue = "0"
    // assert
    // expect
    assert.equal(currentValue.toString(), expectedValue)
    //expect(currentValue.toString()).to.equal(expectedValue)
  })

  //it.only
  it("should update when we call store", async function(){
    const expectedValue = "7"
    const transactionResponse = await simpleStorage.store(expectedValue)  
    await transactionResponse.wait(1)
 
    const currentValue = await simpleStorage.retrieve()
    assert.equal(currentValue.toString(), expectedValue)
     
  })
})
  
   

// describe("SimpleStorage", () => {})
// custom: make function anonymous 

async function main(){
  const SimpleStorageFactory = await ethers.getContractFactory("SimpleStorage")
}