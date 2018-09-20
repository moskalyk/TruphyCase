pragma solidity ^0.4.24;

import "./ITruphyCase.sol";
import 'openzeppelin-solidity/contracts/ECRecovery.sol';
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';

contract Claimable is Ownable {

  using ECRecovery for bytes32;
  
  mapping(address => uint) public nonces_;

  function claim(string _tokenURI, bytes _sig, address _contractAddress) public returns(bool) {
    
    // Recreate the message, which also confirms the msg.sender matches the arguments in the signature
    bytes32 message = keccak256(abi.encodePacked(msg.sender, _tokenURI, nonces_[msg.sender]++, _contractAddress));
    bytes32 preFixedMessage = message.toEthSignedMessageHash();
    
    // Confirm the signature came from the owner, same as web3.eth.sign(...)
    require(owner == ECRecovery.recover(preFixedMessage, _sig));

    return true;
  }

}

// Not Fully ERC721 Compliant 
contract TruphyCase is ITruphyCase, Claimable {

  string public name;
  string public symbol;

  constructor(string _name, string _symbol) {
    name = _name;
    symbol = _symbol;
  }

  event Mint(address indexed _to, string _tokenURI, uint _tokenId, uint indexed _mintType);

  enum MintType { CLAIMED, ISSUED }

  // Token Owner
  mapping (uint256 => address) internal tokenOwner;
  
  // Global index list
  uint[] internal tokensByIndex;

  // Address to owner index list
  mapping (address => uint[]) internal ownerTokenIndexes;

  // Index to URI
  mapping (uint => string) internal tokenURIByIndex;

  // operatorApprovals
  mapping (address => mapping (address => bool)) internal operatorApprovals;

  mapping (string => address[]) trophyTokenOwners;
  

  /**
   * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
   * @param _tokenId uint ID of the token to validate
   */
  modifier canTransfer(uint _tokenId) {

    // Is an Operator, or, can be transferred
    require(isApprovedForAll(ownerOf(_tokenId), msg.sender));
    _;
  }

  /**
   * @dev Tells whether an operator is approved by a given owner
   * @param _owner    address   which you want to query the approval of
   * @param _operator address   operator address which you want to query the approval of
   * @return bool whether the given operator is approved by the given owner
   */
  function isApprovedForAll(
    address _owner,
    address _operator
  )
    public
    view
    returns (bool)
  {
    return operatorApprovals[_owner][_operator];
  }

   /**
   * @dev Mints an NFT using a token URI
   * @param _recipientAddr    address     the recipient who will recieve the token
   * @param _tokenURI         string      the string of where the tokenURI is held
   * @param _tokenId          uint        the uint of the token
   * @return bool whether token was minted
   */
  function _mint(address _recipientAddr, string _tokenURI, uint _tokenId, uint _mintType) internal returns (bool){

    // Updating indexes
    ownerTokenIndexes[_recipientAddr].push(_tokenId);
    tokensByIndex.push(_tokenId);

    // Added for Metadata Extension
    tokenURIByIndex[_tokenId] = _tokenURI;

    // tokenOwner
    tokenOwner[_tokenId] = _recipientAddr;

    // Token recipient
    trophyTokenOwners[_tokenURI].push(_recipientAddr);

    // Log the Event
    emit Mint(_recipientAddr, _tokenURI, _tokenId, _mintType);

    return true;
  }

  /**
   * @dev Claims a trophy / token that is assigned via a message signature
   * @param _tokenURI string  the string of where the tokenURI is held
   * @param _sig      bytes   signature of the message
   * @return bool             whether token was claimed
   */
  function claimTrophy(string _tokenURI, bytes _sig) public returns (bool) {

    // Ensure's that the owner cant claim trophies for themselves
    require (msg.sender != owner, "Sender is the owner of the contract");

    // Claim and record the nonce
    require(super.claim(_tokenURI, _sig, address(this)), "Signature is invalid");

    // Mint
    _mint(msg.sender, _tokenURI, tokensByIndex.length + 1, uint(MintType.CLAIMED));

    return true;
  }

  /**
   * @dev Assigns a user a trophy using a minting function
   * @param _recipientAddr address  the recipient who will recieve the token
   * @param _tokenURI      string   the string of where the tokenURI is held
   * @return bool whether token was assigned
   */
  function assignTrophy(address _recipientAddr, string _tokenURI) onlyOwner() returns (bool) {
    
    // Mint
    _mint(_recipientAddr, _tokenURI, tokensByIndex.length + 1, uint(MintType.ISSUED));

    return true;
  }

  /**
   * @dev Returns the address the tokens are minted to
   * @param _tokenURI string the string of where the tokenURI is held
   * @return address[] list of addresses the trophies are minted to
   */  
  function trophyOfTokenOwners(string _tokenURI) public returns(address[]) {
    return trophyTokenOwners[_tokenURI];
  }

  /// Token Metadata Extension
  /**
   * @dev Returns the name
   * @return string name 
   */ 
  function name() external view returns (string _name){
      _name = _name;
  }

  /**
   * @dev Returns the symbol
   * @return string symbol 
   */ 
  function symbol() external view returns (string _symbol){
      _symbol = _symbol;
  }

  /**
   * @dev Returns the tokenUri
   * @return string _tokenUri 
   */ 
  function tokenURI(uint256 _tokenId) external view returns (string){
    require (_tokenId < tokensByIndex.length);
    return tokenURIByIndex[_tokenId];
  }

  /// Token Enumerable Extension
  /*
   * @dev Returns total supply
   * @returns uint count of supply
  */
  function totalSupply() returns (uint){
    return tokensByIndex.length;
  }

  /*
   * @dev Gets the token at the index
   * @param uint256 index of the token
   * @returns 
  */
  function tokenByIndex(uint256 _index) external view returns(uint256){
    require(_index < tokensByIndex.length);
    return tokensByIndex[_index];
  }

  /*
   * @dev Gets the token for the owner by the index located in the index list
   * @param address _owner owner we are looking up the token for
   * @param uint _index the index within the owners list
   * @returns the global index list
  */
  function tokenOfOwnerByIndex (address _owner, uint _index)  external view returns(uint) {
    require(_index < ownerTokenIndexes[_owner].length);
    require (_owner != address(0));
    return ownerTokenIndexes[_owner][_index];
  }

  // Basic ERC721 Functions

  /**
   * @dev Gets the balance of the specified address
   * @param _owner address to query the balance of
   * @return uint256 representing the amount owned by the passed address
   */
  function balanceOf(address _owner) public view returns (uint256) {
    require(_owner != address(0));
    return ownerTokenIndexes[_owner].length;
  }

  /**
   * @dev Gets the owner of the specified token ID
   * @param _tokenId uint256 ID of the token to query the owner of
   * @return owner address currently marked as the owner of the given token ID
   */
  function ownerOf(uint256 _tokenId) public view returns (address) {
    address owner = tokenOwner[_tokenId];
    require(owner != address(0));
    return owner;
  }

  /**
   * @dev Returns whether the specified token exists
   * @param _tokenId uint256 ID of the token to query the existence of
   * @return whether the token exists
   */
  function exists(uint256 _tokenId) public view returns (bool) {
    address owner = tokenOwner[_tokenId];
    return owner != address(0);
  }

}