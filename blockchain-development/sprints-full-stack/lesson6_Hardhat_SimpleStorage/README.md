## Lesson 6 Hardhat fundme

### hardhat setup
* yarn = npm
* yarn = npx
* yarn add --dev prettier prettier-plugin-solidity
* deployed to specifc network: `yarn hardhat run scripts/deploy.js --network hardhat`
* env: yarn add --dev dotenv
* useful: `yarn hardhat run scripts/deploy.js --network goerli --show-stack-traces`


## How to visualize smart contract 
* ref: https://www.youtube.com/watch?v=Nv-dV69lIQw&ab_channel=EatTheBlocks

## surya: for visulize solidity code
*`surya graph contracts/**/*.sol | dot -Tpng > MyContract.png`

## Need fix: verify on testnet failed
* `yarn hardhat run scripts/deploy.js --network georli                    `
* `yarn hardhat run scripts/deploy.js --network georli --show-stack-traces`
* `yarn hardhat run scripts/deploy.js --network goerli `

## Hardhat custom task
* `yarn hardhat block-number`
* `yarn hardhat block-number --network goerli`

## hardhat localhost node
* `yarn hardhat node`
* `yarn hardhat run scripts/deploy.js --network localhost`

## quick short cut
* control(^) + ` -> terminal


## The hardhat console
* `yarn hardhat console`

* `yarn hardhat node`
* `yarn hardhat console --network localhost`
* `yarn hardhat console --network goerli`

* yarn hardhat clean

## Running tests
* works with mochajs 
* `yarn hardhat test`
* `yarn hardhat test --grep keyword`


## Hardhat gas reporter
* see how much gas each function cost gas
* hardhat-gas-reporter plugin
* `yarn add hardhat-gas-reporter --dev`
·----------------------------|----------------------------|-------------|-----------------------------·
|    Solc version: 0.8.8     ·  Optimizer enabled: false  ·  Runs: 200  ·  Block limit: 30000000 gas  │
·····························|····························|·············|······························
|  Methods                                                                                            │
··················|··········|··············|·············|·············|···············|··············
|  Contract       ·  Method  ·  Min         ·  Max        ·  Avg        ·  # calls      ·  usd (avg)  │
··················|··········|··············|·············|·············|···············|··············
|  SimpleStorage  ·  store   ·           -  ·          -  ·      43724  ·            2  ·          -  │
··················|··········|··············|·············|·············|···············|··············
|  Deployments               ·                                          ·  % of limit   ·             │
·····························|··············|·············|·············|···············|··············
|  SimpleStorage             ·           -  ·          -  ·     463682  ·        1.5 %  ·          -  │
·----------------------------|--------------|-------------|-------------|---------------|-------------·


## Solidity Coverage
* solidity-coverage : check how many lines of our .sol code is covered in a test
* `yarn add --dev solidity-coverage`

## hardhat waffle

## lesson 6 recap 