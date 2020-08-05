pragma solidity '0.6.9';

import "./access/Ownable.sol";

interface UpgradableProxyInitializable {
    function initialize(address _logic, address _admin, bytes memory _data) external;
    function changeAdmin(address newAdmin) external;
    function upgradeTo(address newImplementation) external;
    function upgradeToAndCall(address newImplementation, bytes calldata data) external;
}

contract Application is Ownable {
    event ProxyCreated(address proxy);
    event ProxyUpgraded(address logic);

    uint256 public currentVersion;
    mapping(uint256 => address) public versionHistory;
    address public template;
    address public instance;

    constructor(address _template) public {
        template = _template;
    }

    function deployInstance()
        external
        onlyOwner
        returns (address proxy)
    {
        bytes20 targetBytes = bytes20(template);
        assembly {
            let clone := mload(0x40)
            mstore(
                clone,
                0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000
            )
            mstore(add(clone, 0x14), targetBytes)
            mstore(
                add(clone, 0x28),
                0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000
            )
            proxy := create(0, clone, 0x37)
        }

        emit ProxyCreated(address(proxy));
        instance = proxy;

        UpgradableProxyInitializable(proxy).initialize(address(1), address(this), "");
    }

    function rollup(bytes memory _code, bytes memory _data) external onlyOwner {
        uint256 salt = uint256(keccak256(_data));
        address newVersion = _deploy(_code, salt);
        if (_data.length > 0) {
            UpgradableProxyInitializable(instance).upgradeToAndCall(newVersion, _data);
        } else {
            UpgradableProxyInitializable(instance).upgradeTo(newVersion);
        }
        currentVersion++;
        versionHistory[currentVersion] = newVersion;
    }

    function unwrapAdmin(address _newAdmin) onlyOwner external {
        UpgradableProxyInitializable(instance).changeAdmin(_newAdmin);
    }

    function _deploy(bytes memory code, uint256 salt) internal returns (address) {
        address addr;
        assembly {
            addr := create2(0, add(code, 0x20), mload(code), salt)
            if iszero(extcodesize(addr)) {
                revert(0, 0)
            }
        }
        return addr;
    }
}
