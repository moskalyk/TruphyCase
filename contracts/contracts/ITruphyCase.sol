
pragma solidity ^0.4.24;

/*
 * Interface for the TruphyCase Contract
 */
interface ITruphyCase {
  function claimTrophy (string _tokenURI, bytes _sig) public returns(bool res);
  function assignTrophy (address _recipientAddr, string _tokenURI) public returns(bool res);
  
  // TODO?
  // function issueTrophy (string _tokenURI) public returns(bool res);
  // function revokeTrophy (uint _tokenId) public returns(bool res);
}


