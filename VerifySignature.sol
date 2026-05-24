/*

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
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
 * ─────────────────────────────────────────────────────────────
 *  Signature Verification
 * ─────────────────────────────────────────────────────────────
 *
 *  Digital signatures allow a party to prove ownership of a private
 *  key without ever revealing it. This contract demonstrates how to
 *  create, sign, and verify Ethereum messages on-chain.
 *
 *  The full process is split into two phases:
 *
 *  SIGNING (done off-chain by the signer):
 *    1. Define the message parameters (_to, _amount, _message, _nonce).
 *    2. Hash the parameters into a compact bytes32 message hash.
 *    3. Sign the hash using MetaMask or web3; this produces a signature.
 *
 *  VERIFYING (done on-chain by this contract):
 *    1. Recreate the message hash from the original parameters.
 *    2. Recover the signer's address from the signature and hash.
 *    3. Compare the recovered address to the claimed signer address.
 *       If they match → the signature is authentic.
 *
 * ─────────────────────────────────────────────────────────────
 */

contract VerifySignature {
    /*
     * ── STEP 1: Unlock MetaMask and request account access ──────────────
     *
     * Run this in your browser console before signing:
     *
     *   const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
     *   
     *   Make sure that you are connecting by runnding the command
     *   window.ethereum
     *   If an object appear, then all is good but if "undefined" is shown then the MetaMask account isn't connected
     * 
     * This prompts the user to connect their MetaMask wallet and returns
     * an array of available account addresses.
     */

    /*
     * ── STEP 2: Generate the message hash ───────────────────────────────
     *
     * Call getMessageHash() with your parameters to produce the hash.
     * Example inputs:
     *   _to      = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 (Remix Test Account 2 Address)
     *   _amount  = 123
     *   _message = "coffee and donuts"
     *   _nonce   = 1
     *
     * Expected output:
     *   hash = "0x56f00a5093efc595178316938b3e9ab51b37610ca57b1b471aa4ce801f05251d"
     */

    /**
     * @notice Hashes the message parameters into a compact bytes32 digest.
     * @dev    Uses abi.encodePacked to tightly pack all parameters before hashing.
     *         The nonce ensures that identical messages produce different hashes,
     *         preventing replay attacks (reusing a valid signature maliciously).
     *
     * @param _to      The recipient's address.
     * @param _amount  The ETH amount (in wei) involved in the transaction.
     * @param _message An arbitrary string message to include in the hash.
     * @param _nonce   A unique number to differentiate otherwise identical messages.
     * @return         The keccak256 hash of the packed parameters.
     */
    function getMessageHash(
        address _to,
        uint256 _amount,
        string memory _message,
        uint256 _nonce
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_to, _amount, _message, _nonce));
    }

    /*
     * ── STEP 3: Sign the message hash off-chain ──────────────────────────
     *
     * Use personal_sign to sign the hash with your MetaMask account.
     * Note: the params order is [hash, account] for personal_sign.
     *
     *   const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
     *
     *   const signature = await ethereum.request({
     *     method: 'personal_sign',
     *     params: [
     *       "0x56f00a5093efc595178316938b3e9ab51b37610ca57b1b471aa4ce801f05251d",
     *       accounts[0]
     *     ]
     *   });
     *
     *   console.log(signature);
     *
     * Example output (signature):
     *   0x1064e4bf90f87bbac70e8e23f034a409c348709159b74662a0d5c35512897e93
     *   3bd18f15757c689882f12ee447fb8e59070bebeb60d009647ce29994cb2ec92c1c
     *
     * Signatures differ per account; the same message signed by two different
     * wallets will always produce two completely different signatures.
     */

    /**
     * @notice Wraps a raw message hash in Ethereum's standard signing prefix.
     * @dev    MetaMask and other wallets automatically prepend the prefix:
     *           "\x19Ethereum Signed Message:\n32"
     *         before signing, to prevent a signature from being mistaken for
     *         a valid on-chain transaction. We must apply the same prefix here
     *         before recovering the signer, or ecrecover() will return the wrong address.
     *
     *         The "32" refers to the byte length of the keccak256 hash being signed.
     *
     * @param _messageHash  The raw keccak256 hash produced by getMessageHash().
     * @return              The prefixed hash ready for signer recovery.
     */
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

    /*
     * ── STEP 4: Recover and verify the signer's address ─────────────────
     *
     * To recover the signer's address off-chain before calling verify():
     *
     *   const hash = "0x56f00a5093efc595178316938b3e9ab51b37610ca57b1b471aa4ce801f05251d";
     *   const signature = "0x1064e4bf90f87bbac70e8e23f034a409c348709159b74662a0d5c35512897e93
     *                       3bd18f15757c689882f12ee447fb8e59070bebeb60d009647ce29994cb2ec92c1c";
     *
     *   const signer = await ethereum.request({
     *     method: "personal_ecRecover",
     *     params: [hash, signature]
     *   });
     *
     *   console.log(signer);
     *   // → 0xf54ea090d66ac6903cae152d7e35ea0ff59b42cc
     *
     * Then call verify() on-chain with:
     *   _signer    = 0xf54ea090d66ac6903cae152d7e35ea0ff59b42cc
     *   _to        = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
     *   _amount    = 123
     *   _message   = "coffee and donuts"
     *   _nonce     = 1
     *   _signature = 0x1064e4bf90f87bbac70e8e23f034a409c348709159b74662a0d5c35512897e93
     *                  3bd18f15757c689882f12ee447fb8e59070bebeb60d009647ce29994cb2ec92c1c
     */

    /**
     * @notice Verifies that a given signature was produced by the claimed signer.
     * @dev    Recreates the signed hash from the original parameters, recovers
     *         the signer's address from the signature, and compares it to `_signer`.
     *         Returns true only if the addresses match exactly.
     *
     * @param _signer    The address claiming to have signed the message.
     * @param _to        The recipient address used when creating the message.
     * @param _amount    The amount used when creating the message.
     * @param _message   The string message used when creating the message.
     * @param _nonce     The nonce used when creating the message.
     * @param signature  The raw signature bytes produced by personal_sign.
     * @return           True if the signature is valid and matches `_signer`.
     */
    function verify(
        address _signer,
        address _to,
        uint256 _amount,
        string memory _message,
        uint256 _nonce,
        bytes memory signature
    ) public pure returns (bool) {
        // Step 1: Recreate the original message hash from the parameters.
        bytes32 messageHash = getMessageHash(_to, _amount, _message, _nonce);

        // Step 2: Apply the Ethereum signed message prefix to match what was signed.
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        // Step 3: Recover the signer and compare to the claimed address.
        address recovered = recoverSigner(ethSignedMessageHash, signature);
        require(recovered != address(0), "Invalid signature");
        return recovered == _signer;
    }

    /**
     * @notice Recovers the address that signed a given hash.
     * @dev    Uses Solidity's built-in ecrecover() precompile.
     *         ecrecover takes the signed hash and the three signature components
     *         (v, r, s) and mathematically derives the signer's public key,
     *         then returns the corresponding Ethereum address.
     *         Returns address(0) if the signature is invalid.
     *
     * @param _ethSignedMessageHash  The prefixed hash (output of getEthSignedMessageHash).
     * @param _signature             The raw 65-byte signature to recover from.
     * @return                       The address that produced the signature.
     */
    function recoverSigner(
        bytes32 _ethSignedMessageHash,
        bytes memory _signature
    ) public pure returns (address) {
        // Split the signature into its three components before passing to ecrecover.
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);

        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    /**
     * @notice Splits a 65-byte signature into its three components: r, s, and v.
     * @dev    An Ethereum signature is exactly 65 bytes, structured as:
     *           [0..31]  → r (32 bytes): x-coordinate of the elliptic curve point.
     *           [32..63] → s (32 bytes): proof component of the signature.
     *           [64]     → v (1 byte):  recovery identifier, either 27 or 28.
     *
     *         This function uses inline assembly (low-level EVM code) to read
     *         directly from memory, since Solidity has no native way to slice
     *         a bytes value into fixed-size chunks.
     *
     *         mload(p) reads 32 bytes starting at memory address p.
     *         The first 32 bytes of a `bytes memory` variable store its length,
     *         so we skip ahead by 32 bytes before reading r, s, and v.
     *
     * @param sig  The raw 65-byte signature.
     * @return r   First 32 bytes of the signature.
     * @return s   Second 32 bytes of the signature.
     * @return v   Final byte — the recovery identifier.
     */
    function splitSignature(
        bytes memory sig
    ) public pure returns (bytes32 r, bytes32 s, uint8 v) {
        // A valid Ethereum signature is always exactly 65 bytes.
        require(sig.length == 65, "invalid signature length");

        assembly {
            // Skip the first 32 bytes (the `bytes` length prefix stored by Solidity).
            // Read bytes 0–31  → r
            r := mload(add(sig, 32))
            // Read bytes 32–63 → s
            s := mload(add(sig, 64))
            // Read byte 64     → v (extract only the first byte of the loaded 32 bytes)
            v := byte(0, mload(add(sig, 96)))
        }

        // Normalise v to 27 or 28.
        // Some signers (web3.py, ethers.js, hardware wallets) return v as 0 or 1.
        // ecrecover() requires 27 or 28 and returns address(0) for anything else.
        if (v < 27) v += 27;

        // Reject signatures where s is in the upper half of the curve order.
        // Every signature has a mirrored form with a different s value that is
        // also mathematically valid. Restricting s to the lower half ensures
        // each message can only have one valid signature, preventing an attacker
        // from replaying a mirrored version of a legitimate signature.
        require(
            uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0,
            "Invalid signature: s value out of range"
        );

        // r, s, v are returned implicitly via named return variables.
    }
}
