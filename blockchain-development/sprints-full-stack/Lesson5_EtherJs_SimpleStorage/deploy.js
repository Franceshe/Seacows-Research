// synchronous [solidity]
// asynchronous [javascript]

//Analogy: cooking

// Synchronous
// 1. Put popcorn n microwave -> Promise
// 2

// Asynchronous

// Promise
// Pending
// Fulfilled
// Rejected

async function main() {
  console.log("hi");
  let variable = 5;
  console.log(variable);
  // deploy a contract? Wait for it to be deployed
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
