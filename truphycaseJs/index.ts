
// Node module to interact with the TruphyCase Contract
import Web from 'web3';

function connectToContracts(web3, abi, address) {
	return new web3.eth.Contract(abi, address);
}

interface ITruphyCase {

	//Returns a boolean to confirm that the trophy has been assigned
	claimTruphy(tokenURI: string, signature: string): boolean;

	//Returns a boolean to confirm that the trophy has been assigned
	assignTruphy(userAddress: string, trophyId: number): boolean;

	// Return a list of json for the games Trophies
	getBalance(gameId): number;

	// Return a list of json for the users Trophies
	get(userAddress: string): [Object];

	//TODO: Implement Metadata iteration
}

class TruphyCase /* implements ITruphyCase */ {
	private _gameId: number;
	private _contractABI: [];
	private _web3: Web;
	private _TruphyCaseContractAddress: string;
	private _TruphCase: TruphyCase;

	constructor(config: any){ 
		this._gameId = config.gameId;
		this._contractABI = config.contractABI;
		this._web3 = config.web3;
		this._TruphyCaseContractAddress = config.truphyCaseContractAddress;
		this._TruphCase = connectToContracts(this._web3, this._contractABI, this._TruphyCaseContractAddress);
	}

	// TODO: Implement functions

	// //Returns a boolean to confirm that the trophy has been assigned
	// public claimTruphy(tokenURI: string, signature: string): Promise<boolean> {
	// 	return new Promise<number>(r => r(true));
	// }

	// //Returns a boolean to confirm that the trophy has been assigned
	// public assignTruphy(userAddress: string, trophyId: number): Promise<boolean> {
	// 	return new Promise<number>(r => r(true));
	// }

	// // Return a list of json for the games Trophies
	// public async getBalance(userAddress: string): Promise<number> {
	// 	return new Promise<number>(r => r(0));
	// }

	// // Return a list of json for the users Trophies
	// get(userAddress: string): [Object];
}

export default TruphyCase;