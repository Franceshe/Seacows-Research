//SPDX-Lisence-Identifier: MIT
pragma solidity ^0.5.11;
// Merkle tree of array 2^n
// not power of 2? -> duplicate the last element
// eg: h21 = hashing(h12, h12)

// A cryptographic proof that a tx is block
// tx1, tx2, tx3 => compute the merkle root hash -> O(logN)
// hash(tx1 + tx2 + tx3 + ...) -> O(N)

//a function to verify a merkle proof
contract MerkleProof{
    function verify(
        bytes32[] memory proof, bytes32 root, bytes32 leaf, uint index
    ) public pure returns (bool){
        bytes32 hash = leaf;

        // recompute merkle root
        for(uint i = 0;  i < proof.length; i++){
            if(index%2 == 0){
                hash =  keccak256(abi.encodePacked(hash, proof[i]));
            } else{
                hash = keccak256(abi.encodePacked(proof[i], hash));
            }
            index = index /2;
        }
        return hash == root;

    }

} 
