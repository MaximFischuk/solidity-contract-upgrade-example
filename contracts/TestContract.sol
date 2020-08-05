pragma solidity '0.6.9';

import './access/Ownable.sol';

contract Test is Ownable {

    uint256 public value;

    modifier noInitialized() {
        require(address(owner()) == address(0), 'Contract already initialized');
        _;
    }

    function init(address _owner, uint256 _value) public noInitialized {
        Ownable.transferOwnership(_owner);
        value = _value;
    }

}