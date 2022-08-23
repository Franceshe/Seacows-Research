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
