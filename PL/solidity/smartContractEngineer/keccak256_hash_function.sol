// SPDX-License-Identifier: MIT

pragma solidity ^0.8.3;

contract HashFunc {
    function hash(string memory text, uint num, address addr) external pure returns (bytes32){
        return keccak256(abi.encodePacked(text, num, addr));  //put bytes as encode
    }

    //abi.encode vs -> encode data into bytes
    //abi.encodePacked -> encode data into bytes but smaller
    // Hash collision
    function encode(string memory text0, string memory text1) external pure returns(bytes memory){
        return abi.encode(text0, text1);
        
    }

    /*Given same input "AAA", "BBB"*/
    /* Hash collision "AAA", "ABBB"*/
    /*
    0:
        bytes: 0x00000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000
        00000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000034141410
        00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
        000000000000000034242420000000000000000000000000000000000000000000000000000000000"AAA", "BBB"

    */
    function encodePacked(string memory text0, string memory text1) external pure returns(bytes memory){
        return abi.encodePacked(text0, text1);
    }

    /*
    bytes: 0x414141424242
    */
    

    function collision(string memory text0, string memory text1) external pure returns(bytes32){
            return keccak256(abi.encodePacked(text0, text1));
    }

    /* input: "AAA", "ABBB" => same result*/ 
    /* input: "AAAA", "BBB"* => same result*/
    // hash collision

    // alternative solution: insert uint x to prevent near dynamic element
    function collision(string memory text0, uint x,  string memory text1) external pure returns(bytes32){
            return keccak256(abi.encodePacked(text0, x,  text1));
    }
        
}



