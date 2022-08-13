//SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;
//progma solidity >=0.8.7 < 0.9.0

contract SimpleStorage {
    // 1. solidty primitive types:
    // boolean, unit(only positve whole number), int (positive or negative whole number), address, bytes
    // side youtube: bits vs bytes as fast
    // unit == unit256
    // unit8 declare the variable we initiated is 8 bit
    bool hasFavoriteNumber = true;
    //uint256 hasFavoriteNumber = 5;
    string favoriteNumberInText = "Five";
    int256 favoriteInt =-5;
    address myAddress = 0xecAA8fd1b3892994291bf749fB48D7cEfb5D1A5A;
    bytes32 favoriteBytes = "cat"; // typically 0x123653646478
    //string are bytes objects only for text
    //bytes32 is yhe max for bytes

    // This gets iiniitialized in zero if without specify
    uint256 public favoriteNumber;    // -> now visibility is public

    //2. <Basic solidity functions >
    // "functions" or "Methods " execute a subset of code when called
    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
        //uint256 testVar = 5;
        //favoriteNumber = favoriteNumber + 1; //amount of gas increased, the more stuff we do, more gas fee.

    }

    //note: every smart contract has an address just like wallet
    //0xd9145CCE52D386f254917e481eB44e9943F39138
    
    //deploy a contract or aka any time you change something on-chain, 
    //including making a new contract, it happends in a transaction

    // 3.check https://docs.soliditylang.org/en/v0.8.16/cheatsheet.html
    // for function visibility specifiers
    // public/privte/external/internal
    // public: public variable implicitly get assigned a function that returns its value

    // the default visibility is interal;

    //_name convention is to differentiate from the original var


    //4. Scope
    // not gonna work
    // function something() public {
    //     testVar = 6; //??

    // }


    // 5.<view, pure functions, when called alone, don't spend gas>
    // here view -> read state
    // <view and pure functions disallow modification of state>
    // <Pure functions addtionally disallow you to read from blockchain state>
    function retrieve() public view returns(uint256){
        return favoriteNumber;
    }

    // comment: execution cost	23479 gas (Cost only applies when called by a contract)
    // <If a gas calling function  calls a view or pure function - only then will it cost gas >
    function add() public pure returns(uint256){
        return (1+1);
    }

    //returns: result of calling function
    // similar to C++: type first


    //<BASIC SOLIDITY ARRAY & STRUCTS>

    People public person = People({favoriteNumber: 2, name: "Patrick"});

    //<Array: An array is a data structure that holds a list of other types>    
    struct People{
        uint256 favoriteNumber;
        string name;
    }

    //make a people array for more elegant 
    //<dynamic array vs fixed-size array>, this is a dynamic array
    People[] public people; //<our array(list) is currently empty!>
    //People[3]
    // 0: 2, Patrick , 1: 7, John

   //uint256[] public favoriteNumberList;

    //a function add people who are people array
    // memory keyword
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        //method1: 
        //people.push(People(_favoriteNumber, _name));
        
        //method2:
        //People memory newPerson = People({favoriteNumber: _favoriteNumber, name: _name});
        
        // method3 
        //People memory newPerson = People(_favoriteNumber, _name);
        //people.push(newPerson);

        //method4:
        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }


    //<<BASIC SOLIDITY ERROR & WARNINGS>>
    //< Warning won't stop your code from working/compiling 
    // but it's usually a good idea to check them our>

    //****************************************************
    //<<BASIC SOLIDITY: Memory, Storage, &Calldata(Intro)>>

    //EVM Overview:
    /*
    EVM can access and store information in six places:
    1. Stack
    2. Memory*
    3. Storage*
    4. Calldata*
    5. Code
    6. Logs
    */

    /*
    Calldata and memory : variable exists temperarilty 
    Storage: permanent var can be modified, torage vars existed even out of functions executing
    calldata: temporary var can be modified
    memory: temporary var can not be modified

    Sidework:
    From CS241 OS class: stack vs (Memory allocating)
    */
    //****************************************************

    //<BASIC SOLIDITY MAPPINGS>
    // data structuure mapping: ~dictionary
    /* a mapping is a data structure where a key is "mapped" to a single value*/
    // initlized to zero value
    mapping(string => uint256) public nameToFavoriteNumber;



}