const TruphyCase = artifacts.require("./TruphyCase.sol");

module.exports = function(deployer) {
	deployer.deploy(TruphyCase, "TruphyCase", "TCASE");
};
