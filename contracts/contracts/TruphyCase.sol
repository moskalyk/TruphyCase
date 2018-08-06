pragma solidity ^0.4.24;

import "./ITruphyCase.sol";

import 'openzeppelin-solidity/contracts/ECRecovery.sol';
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';

contract Claimable is Ownable {

  using ECRecovery for bytes32;
  
  mapping(uint256 => bool) nonces_;

  function claim(string _tokenURI, uint256 _nonce, bytes _sig, address _contractAddress) public returns(bool) {
    
    // Make sure the nonce is not used
    require(!nonces_[_nonce]);
    nonces_[_nonce] = true;

    // Recreate the message, which also confirms the msg.sender matches the arguments in the signature
    bytes32 message = keccak256(abi.encodePacked(msg.sender, _tokenURI, _nonce, _contractAddress));
    bytes32 preFixedMessage = message.toEthSignedMessageHash();
    
    // Confirm the signature came from the owner, same as web3.eth.sign(...)
    require(owner == ECRecovery.recover(preFixedMessage, _sig));

    return true;
  }

}

// Not Fully ERC721 Compliant - For demo purposes
contract TruphyCase is ITruphyCase, Claimable {

  constructor(string _name, string _symbol) {}

  event Mint(address _to, string _tokenURI);

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

  // All nonTransferable tokens
  mapping (uint => bool) internal nonTransferable;

  /**
   * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
   * @param _tokenId uint ID of the token to validate
   */
  modifier canTransfer(uint _tokenId) {

    // Is an Operator, or, can be transferred
    require(isApprovedForAll(ownerOf(_tokenId), msg.sender) || nonTransferable[_tokenId] != true);
    _;
  }

  /**
   * @dev Tells whether an operator is approved by a given owner
   * @param _owner owner address which you want to query the approval of
   * @param _operator operator address which you want to query the approval of
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
   * @dev Mints an ERC721 token using a token URI
   * @param _recipientAddr address the recipient who will recieve the token
   * @param _tokenURI string the string of where the tokenURI is held
   * @param _tokenId uint the uint of the token
   * @return bool whether token was minted
   */
  function mint(address _recipientAddr, string _tokenURI, uint _tokenId) internal returns (bool){

    // Updating indexes
    ownerTokenIndexes[_recipientAddr].push(_tokenId);
    tokensByIndex.push(_tokenId);

    // non transferable trophy
    nonTransferable[_tokenId] = false;

    // Added for Metadata Extension
    tokenURIByIndex[_tokenId] = _tokenURI;

    // tokenOwner
    tokenOwner[_tokenId] = _recipientAddr;

    // Log the Event
    emit Mint(_recipientAddr, _tokenURI);

    return true;
  }


  /**
   * @dev Claims a trophy / token that is assigned via a message signature
   * @param _tokenURI string the string of where the tokenURI is held
   * @param _nonce uint to track the unique number
   * @param _sig bytes signature of the message
   * @return bool whether token was claimed
   */
  function claimTrophy(string _tokenURI, uint256 _nonce, bytes _sig) public returns (bool) {

    // Enusre's that the owner cant claim trophies for themselves
    require (msg.sender != owner);

    // Claim and record the nonce
    require(super.claim(_tokenURI, _nonce, _sig, address(this)));

    // Mint
    mint(msg.sender, _tokenURI, tokensByIndex.length + 1 );

    return true;
  }

  /**
   * @dev Assigns from an owner to a trophy id
   * @param _recipientAddr address the recipient who will recieve the token
   * @param _tokenURI string the string of where the tokenURI is held
   * @return bool whether token was claimed
   */
  function assignTrophy(address _recipientAddr, string _tokenURI) public returns (bool) {

    // Ensure's that the owner is 
    require (msg.sender == owner);
    
    // Mint
    mint(_recipientAddr, _tokenURI, tokensByIndex.length + 1 );

    return true;
  }

  function issueTrophy(string _tokenURI) onlyOwner() returns (bool) {

    // Mint Trophy
    mint(msg.sender, _tokenURI, tokensByIndex.length + 1 );

    return true;
  }

  /// Token Metadata Extension

  function name() external view returns (string _name){
      _name = _name;
  }

  function symbol() external view returns (string _symbol){
      _symbol = _symbol;
  }

  function tokenURI(uint256 _tokenId) external view returns (string){
    require (_tokenId < tokensByIndex.length);
    return tokenURIByIndex[_tokenId];
  }

  
  /// Token Enumerable Extension

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
  
  /*
   * @dev Throw due to the fact that the trophy cannot be transferred
   * @param _from current owner of the token
   * @param _to address to receive the ownership of the given token ID
   * @param _tokenId uint256 ID of the token to be transferred
  */
  function transferFrom(address _from, address _to, uint256 _tokenId) canTransfer(_tokenId) public  {
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