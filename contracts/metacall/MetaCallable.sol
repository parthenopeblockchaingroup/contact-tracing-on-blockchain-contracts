pragma solidity <0.7.0;

import "../cryptography/ECDSA.sol";

contract MetaCallable {
    using ECDSA for bytes32;

    event MetaCall(address by, address from);

    mapping(address => uint256) _nonces;

    function nonce(address a) public view returns(uint256) {
        return _nonces[a];
    }

    function metaCall(bytes calldata functioncall, uint256 n, bytes calldata signature) external returns(bool, bytes memory) {
        bytes32 h = hash(functioncall, n);
        address signer = ECDSA.recover(ECDSA.toEthSignedMessageHash(h), signature);

        require(signer != address(0), "Metacall: signer is address zero");
        require(n == _nonces[signer]++, "Metacall: invalid nonce");

        bytes memory payload = abi.encodePacked(functioncall, signer);
        (bool success, bytes memory returned) = address(this).call(payload);
        
        require(success, "Metacall: unable to finalize call");

        emit MetaCall(msg.sender, signer);
        return (success, returned);
    }

    function hash(bytes memory functioncall, uint256 n) public pure returns(bytes32) {
        bytes memory payload = abi.encodePacked(functioncall, n);
        return keccak256(payload);
    }
}