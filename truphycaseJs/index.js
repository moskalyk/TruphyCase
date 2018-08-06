
// Node module to interact with the TruphyCase Contract

function connectToContracts(web3, abi, address) {
	return new web3.eth.Contract(abi, address);
}

class TruphyCase {

	constructor(config){ 
		this._gameId = config.gameId;
		this._contractABI = config.contractABI;
		this._web3 = config.web3;
		this._TruphyCaseContractAddress = config.truphyCaseContractAddress;
		this._TruphCase = connectToContracts(this._web3, this._contractABI, this._TruphyCaseContractAddress);
	}

	//Returns a boolean to confirm that the trophy has been assigned
	async assignTruphy(userAddress, trophyId){}

	// Returns a boolean to confirm that the trophy has been assigned
	async revokeTruphy(userAddress, trophyId){}

	// Return a list of json for the games Trophies
	async getGameTruphies(gameId){}

	// Return a list of json for the users Trophies
	async getUserTruphies(userAddress){}

	async testCall() {
		return "Howdie Ho!";
	}
}

module.exports = TruphyCase;