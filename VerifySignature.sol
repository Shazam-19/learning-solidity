// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
Signature Verification

# How to Sign and Verify Messages:

## Signing a message
1. Create a message to sign
2. Hash the message
3. Sign the hash (off chain, keep your private key secret)

# Verify
1. Recreate hash from original message
2. Recover signer from signature and hash
3. Compare recovered signer to claimed signer
*/

contract VerifySignature {
    // Signing: Step 1 & 2
    function getMessageHash(
        address _to,
        uint256 _amount,
        string memory _message,
        uint256 _nonce
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_to, _amount, _message, _nonce));
    }

    // Signature is produced by signing a keccak256 hash with the following format
    // "\x19Ethereum Signed Message\n" + len(msg) + msg
    // \x19Ethereum Signed Message\n32...message hash goes here...
    function getEthSignedMessageHash(
        bytes32 _messageHash
    ) public pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(
                    "\x19Ethereum Signed Message:\n32",
                    _messageHash
                )
            );
    }

    // Big picture function
    function verify(
        address _signer,
        address _to,
        uint256 _amount,
        string memory _message,
        uint256 _nonce,
        bytes memory signature
    ) public pure returns (bool) {
        bytes32 messageHash = getMessageHash(_to, _amount, _message, _nonce);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        return recoverSigner(ethSignedMessageHash, signature) == _signer;
    }

    function recoverSigner(
        bytes32 _ethSignedMessageHash,
        bytes memory _signature
    ) public pure returns (address) {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);

        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    function splitSignature(bytes memory _sig) public pure returns ( bytes32 r, bytes32 s, uint8 v) {
        require(_sig.length == 65, "Invalid Signature Length");

        assembly {
            r := mload(add(_sig, 32))
            // add(x, y) --> x + y
            // add(_sig, 32) --> skips first 32 bytes since we store the lenghth of a dynamic array in the first 32 bytes 
            // mload(p) loads next 32 bytes starting at the memory address p
            s := mload(add(_sig, 64))
            v := byte(0, mload(add(_sig, 96)))
        }
    }
}
