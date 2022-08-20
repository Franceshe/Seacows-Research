// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Event {
    event Log(string message, uint val);
    // Up to 3 parameters can be indexed
    event IndexedLog(address indexed sender, uint val);
    
    event Message(address indexed _from, address indexed _to, string _message);


    function examples() external {
        emit Log("Foo", 123);
        emit IndexedLog(msg.sender, 123);
    }
    
    //This function logs Message from msg.sender to the _addr, with the message _message.
    // calldata since it is dynamic data
    
    /* Wrong
    function sendMessage(address _addr, string calldata _message) external {
        emit Log(Message(msg.sender, _addr, _message));
        
    }
    
    */
    
    //memory vs calldata
    function sendMessage(address _addr, string memory _message) external {
        emit Message(msg.sender, _addr, _message);
        
        
    }
    
}
