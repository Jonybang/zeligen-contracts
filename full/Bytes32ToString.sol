pragma solidity ^0.4.24;

// File: contracts/Bytes32ToString.sol

library Bytes32ToString {
    function bytes32ToStr(bytes32 _bytes32) public constant returns (string){
        // string memory str = string(_bytes32);
        // TypeError: Explicit type conversion not allowed from "bytes32" to "string storage pointer"
        // thus we should fist convert bytes32 to bytes (to dynamically-sized byte array)

        bytes memory bytesArray = new bytes(32);
        for (uint256 i; i < 32; i++) {
            bytesArray[i] = _bytes32[i];
        }

        return string(bytesArray);
    }
}
