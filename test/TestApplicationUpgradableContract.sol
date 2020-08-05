pragma solidity >=0.4.25 <0.7.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Application.sol";
import "../contracts/UpgradableProxy.sol";
import "../contracts/TestContract.sol";
import "../contracts/TestContractV2.sol";

contract TestApplicationUpgradableContract {

  UpgradableProxy upgradableProxyTemplate;
  Application application;

  function beforeAll() public {
    upgradableProxyTemplate = new UpgradableProxy();
    application = new Application(address(upgradableProxyTemplate));
  }

  function testDeployNewInstanceOfProxy() public {
    Application(application).deployInstance();
    address instance = Application(application).instance();

    Assert.notEqual(instance, address(0), "Instance should be correct address");
  }

  function testDeployAndInitFirstVersionOfTestContract() public {
    bytes memory code = type(Test).creationCode;
    Application(application).rollup(code, abi.encodeWithSignature("init(address,uint256)", this, 42));

    address instance = Application(application).instance();
    uint256 currentVersion = Application(application).currentVersion();
    uint256 value = Test(instance).value();

    Assert.equal(currentVersion, 1, "Version should be 1");
    Assert.equal(value, 42, "Value should be initialized");
  }

  function testDeployUpdatedVersionOfTestContract() public {
    bytes memory code = type(Test2).creationCode;
    Application(application).rollup(code, "");

    address instance = Application(application).instance();
    uint256 currentVersion = Application(application).currentVersion();
    uint256 value = Test2(instance).value();

    Assert.equal(currentVersion, 2, "Version should be 1");
    Assert.equal(value, 42, "Value should be the same as before");

    bytes32 testHash = keccak256(abi.encodePacked("SomeData"));

    Test2(instance).setHash(testHash);

    bytes32 hashInContract = Test2(instance).someHash();

    Assert.equal(hashInContract, testHash, "Hash shoulb be correctly set");
  }

}
