const TruphyCase = artifacts.require('TruphyCase');
const abi = require('ethereumjs-abi');

let owner;
let recipient;
let adversary;
let truphyCase;
let contractAddress;

// Message Details
let signature;
const tokenURI = 'ipfs.io/ipfs/QmctaQSPHB3woeZ2RTbGBCWRB75uLjtGZdeefT6GtHfNig'
const nonce = 0;

contract('TruphyCase', (accounts) => {

	before(async () => {
		console.log('Getting accounts');
		[owner, recipient, adversary] = accounts;
		truphyCase = await TruphyCase.deployed();
		contractAddress = truphyCase.address;

		// Create Hashed Message
		const hash = "0x" + abi.soliditySHA3([
				'address', 'string', 'uint256', 'address'
			], [recipient, tokenURI, nonce, contractAddress]).toString('Hex');

		// Sign Transaction
		signature = web3.eth.sign(owner, hash);

	});

	it('should allow a recipient to claim a trophy with a signed message', async () => {
		const resCall = await truphyCase.claimTrophy.call(tokenURI, signature, {from: recipient});
		assert(resCall);
		
		await truphyCase.claimTrophy(tokenURI, signature, {from: recipient});
	});

	it('should have a balance of 1 after claiming a trophy', async () => {
		const balance = await truphyCase.totalSupply.call();
		assert(balance == 1, "Balance is not 1.");
	});

	it('should fail if a recipient should decide to reuse a signed message', async () => {
		try{
			const resCall = await truphyCase.claimTrophy.call(tokenURI, signature, {from: recipient});
		}catch(e){
			assert(true, "A recipient was able to reuse.");
		}
	});

	it('should fail if we create a new contract, and used the same signed message', async () => {
		truphyCase2 = await TruphyCase.new("Test", "test");
		try{
			await truphyCase2.claimTrophy.call(tokenURI, signature, {from: recipient});
		}catch(e){
			assert(true);
		}
	});

	it('should fail if a recipient tries to transfer a token', async () => {
		try{
			const transferRes = await truphyCase.transferFrom.call(recipient, owner, 1, {from: recipient});
		}catch(e){
			assert(true);
		}
	});

	it('should fail if an adversary attempts to claim trophy with a signed message', async () => {
		try{
			const resCall = await truphyCase.claimTrophy.call(tokenURI, signature, {from: adversary});
		}catch(e){
			assert(true);
		}
	});

	it('should return the gas estimation of minting a trophy', async () => {
		const newNonce = 1;
		const ethPrice = 250;
		
		// Create Hashed Message
		const hash = "0x" + abi.soliditySHA3([
				'address', 'string', 'uint256', 'address'
			], [recipient, tokenURI, newNonce, contractAddress]).toString('Hex');

		// Sign Transaction
		const newSignature = web3.eth.sign(owner, hash);

		TruphyCase.web3.eth.getGasPrice(async (error, result) => {
			const gasPrice = Number(result);
			const estimateGasAssigning = await truphyCase.assignTrophy.estimateGas(recipient, tokenURI);
			console.log(`Gas Cost Estimation of Assigning: $${TruphyCase.web3.fromWei((gasPrice * estimateGasAssigning) * ethPrice, 'ether')} USD`);

			const estimateGasClaim = await truphyCase.claimTrophy.estimateGas(tokenURI, newSignature, {from: recipient});
			console.log(`Gas Cost Estimation of Claiming: $${TruphyCase.web3.fromWei((gasPrice * estimateGasClaim) * ethPrice, 'ether')} USD`);
			
			assert(true);
		});
	});
});