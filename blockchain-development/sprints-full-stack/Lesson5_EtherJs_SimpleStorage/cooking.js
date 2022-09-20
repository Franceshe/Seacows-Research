// An example to illustrte async-wait in js

// Move Night 

// Cook poporn 
// Pour Drinks
// Start Movie 


async function setupMovieNight(){
    await cookPopcorn();
    await pourDrinks();
    startMovie();

}

function cookPopcorn(){
    // some code here
    return Promise(/**/)

}