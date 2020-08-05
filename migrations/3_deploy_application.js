const UpgradableProxy = artifacts.require("UpgradableProxy");
const Application = artifacts.require("Application");

module.exports = function(deployer) {
    deployer.deploy(Application, UpgradableProxy.address);
};
