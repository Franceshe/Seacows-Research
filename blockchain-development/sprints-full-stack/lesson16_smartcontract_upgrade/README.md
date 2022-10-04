## Upgradable smart contracts

### 1. Not Really / Parameterize
* eg, setter function
* simple but not flexible
* If you did not think through while design smart contract first time, you are scrued
* only admin edit

### 2. Contract registry
* innovated by AAVE: Addressess Provider Registry
* still not flexbile

### 3. Social YEET/Migration
* eg: AAVE V1 -> AAVE V2
* True immutable

- Pros:
* Truest to blockchain values
* Easiest to audit

- Cons
* Lot of work to convince users to move
* Different addresses

- Reference: Trail of bits => How contract migration works

## Proxy!
* truest form of programtic upgrades
* Others may argue the YEET is the truest
* Mainly used "Delegatecall" functionality
* Delegate call is a low level function in which the code in the target contract is exucuted in the 
context of calling contract, while msg.sender and msg.value don't change.
* Fallback function

### Proxy Terminology:
1. The Implementation Contract:
- Which has all our code of our protocol. When we upgrade, we launch a brand new implementation contract
2. The proxy contract
- Which points to which implementation is the "correct" one, and routes everyone's function calls to that contract
3. The user
- They make calls to the proxy
4. The admnin
* This is the user(or group of users/voters) who upgrade to new implemenation contracts.

- Note: all storage variable stored in Proxy contract

### GOTCHAS
1. Storage Clashes
2. Function selector Clashes

- What is Function selector: 
* a 4 bute hash of a function name and function signature that define a function.

### Proxy Patterns
- 1. Transparent Proxy pattern:
* Methodology: admin are only allowed to call admin functions, while admin functions are functions that
govern the upgrades, admin can't call any function in implementation contracts, Users can't call admin
contracts but can call functions in implementation contracts
* In short: Admin functions are functions that govern the upgrades. Admin functions are located in the proxy contract.

- 2. Universal Upgradeable Proxies(UUPS)
* Methodology: the pattern put all the logic of upgrading in the implementation itself
* AdminOnly upgrades functions are in the implementation contracts instead of the proxy
* Gas saver


- 3. Diamond Pattern
* Methodolog; Multiple implementation contracts.

### Delegatecall








