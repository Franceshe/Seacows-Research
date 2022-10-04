## hardhat setup

-   yarn init
-   yarn add --dev hardhat
-   yarn add --dev @chainlink/contracts

## Introduction to Events

-   Events

```
        // Events: whenever update an dynamic object, like an array or mapping
        // we always want to emit event
```

-   Logging and Events
-   Viewing events
-   Events in hardhat
-   EVM:
    -   EVM can emit logs
-   Logs and Events are often used synonymously

*   event allows you to "print" stuff to this log
*   smart contract can't access logs
*   events are ties to smart contracts
*   For too many events. index and querry later

-   eg

*   event storedNumber(
    uint256 indexed oldNumber,
    uint256 indexed newNumber,
    uint256 addedNumber,
    address sender
    )
*   "indexed" keyword
*   Indexed Parameters = Topics
*   Indexed parameters are mucn easier to search

-   example for emit an event

```
emit storedNumber(
    favoriteNumber,
    _favoriteNumber,
    _favoriteNumber + favoriteNumber,
    msg.sender

)
```

### Introduction to Chainlink VRF(randomness)

-   Implement with Chainlink VRF
