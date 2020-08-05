pragma solidity '0.6.9';

import './access/Ownable.sol';
import './TestContract.sol';

contract Test2 is Ownable, Test {

    bytes32 public someHash;

    function setHash(bytes32 _hash) public onlyOwner {
        someHash = _hash;
    }

}