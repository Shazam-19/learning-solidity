// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
Merkle Proof Verification

This contract demonstrates how to verify that a leaf (data item)
belongs to a Merkle Tree using a Merkle proof.

Key Concepts:
- Leaf: hashed data (e.g., transaction)
- Proof: array of sibling hashes used to reconstruct the path to the root
- Root: final hash representing the entire tree
- Index: position of the leaf in the tree (used to determine hash order)
*/

contract MerkleProof {

    // Verifies that a leaf is part of a Merkle tree
    function verify(
        bytes32[] memory proof, // sibling hashes
        bytes32 root,           // expected Merkle root
        bytes32 leaf,           // leaf to verify
        uint256 index           // position of the leaf in the tree
    ) public pure returns (bool) {

        // Start with the leaf hash
        bytes32 hash = leaf;

        // Recompute the hash up to the root using the proof
        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];

            // Determine hash order based on index (left/right position)
            // Even → current node is LEFT
            // Odd → current node is RIGHT
            if (index % 2 == 0) {
                // Index is even, current node is left, so hash = hash(left, right)
                hash = keccak256(abi.encodePacked(hash, proofElement));
            } else {
                // If index is odd, current node is right, so hash = hash(right, left)
                hash = keccak256(abi.encodePacked(proofElement, hash));
            }

            // Move up to the next level in the tree
            index = index / 2;
        }

        // Valid if computed hash matches the root
        return hash == root;
    }
}

contract TestMerkleProof {

    // Stores all hashes (leaves + intermediate nodes + root)
    bytes32[] public hashes; // fixed-size hash (32 bytes)

    // Runs once when deployed
    constructor() {

        // Sample transactions (leaf data)
        string[4] memory transactions =
            ["alice -> bob", "bob -> dave", "carol -> alice", "dave -> bob"];

        // Step 1: Hash all transactions to create leaf nodes
        for (uint256 i = 0; i < transactions.length; i++) {
            hashes.push(keccak256(abi.encodePacked(transactions[i])));
        }

        uint256 n = transactions.length; // number of nodes at current level
        uint256 offset = 0;              // starting index of current level

        // Step 2: Build the Merkle tree level by level until the tree is fully built
        // Each loop builds one level
        while (n > 0) {

            // Hash pairs of nodes (e.g., (0,1), (2,3), etc.) to build the next level
            for (uint256 i = 0; i < n - 1; i += 2) {
                // Take two hashes, combine them, hash the result, and store it
                hashes.push(
                    keccak256(
                        abi.encodePacked(
                            hashes[offset + i],         // left node (even)
                            hashes[offset + i + 1]      // right node (odd)
                        )
                    )
                );
            }

            // Move offset to the next level
            offset += n;

            // Each level has half the number of nodes
            n = n / 2;
        }
        /*
            # Initital state:
            hashes = [h1, h2, h3, h4]
            n = 4
            offset = 0

            # First level iteration:
            → hash(h1 + h2) = h12
            → hash(h3 + h4) = h34

            → hashes = [h1, h2, h3, h4, h12, h34]
            offset = 0 + 4 = 4 (This means: 4 nodes processed and next level starts at index 4)
            n = 4 / 2 = 2 (This means: we only have 2 nodes in this level)

            # Second iteration
            hashes[4] and hashes[5] → hAB and hCD
            hAB + hCD → ROOT
            hashes = [hA, hB, hC, hD, hAB, hCD, ROOT]
            offset = 4 + 2 = 6 (Root is at index 6)
            n = 2 / 2 = 1 (We have only 1 node in this level which is the root)

            n = 1 and for (i < n - 1) → for (i < 0) ❌
            No more hashing → loop ends

            Index:   0   1   2   3   4    5    6
            Data:   hA  hB  hC  hD  hAB  hCD  ROOT

            Simple analogy
            - Level 0 (offset=0, n=4):  hA  hB  hC  hD
            - Level 1 (offset=4, n=2):  hAB  hCD
            - Level 2 (offset=6, n=1):  ROOT
        */
    }

    // Returns the Merkle root (last element in the hashes array)
    function getRoot() public view returns (bytes32) {
        return hashes[hashes.length - 1];
    }

    /*
    Example for verification:

    Leaf (3rd transaction hash):
    0xdca3326ad7e8121bf9cf9c12333e6b2271abe823ec9edfe42f813b1e768fa57b

    Root:
    0xcc086fcc038189b4641db2cc4f1de3bb132aefbd65d510d817591550937818c7

    Index:
    2

    Proof (sibling hashes):
    0x8da9e1c820f9dbd1589fd6585872bc1063588625729e7ab0797cfc63a00bd950
    0x995788ffc103b987ad50f5e5707fd094419eb12d9552cc423bd0cd86a3861433
    */
}