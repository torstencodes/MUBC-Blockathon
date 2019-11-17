const KeyChain = artifacts.require("KeyChain");

module.exports = function(deployer) {
  deployer.deploy(KeyChain);
};
