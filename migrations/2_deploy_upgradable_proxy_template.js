const UpgradableProxy = artifacts.require("UpgradableProxy");

module.exports = function(deployer) {
  deployer.deploy(UpgradableProxy);
};
