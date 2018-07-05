pragma solidity ^0.4.19;

// This imports both ERC721Metadata and ERC721Enumerable
import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol';

/**
 * The TruphyCase contract does this and that...
 */
contract TruphyCase is ERC721Token {
	constructor(string _name, string _symbol) {
	}	

    function testCall() public returns (bool){
        return true;
    }
}
