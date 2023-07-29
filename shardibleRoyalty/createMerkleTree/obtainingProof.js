import { StandardMerkleTree } from "@openzeppelin/merkle-tree";
import fs from "fs";


const tree = StandardMerkleTree.load(JSON.parse(fs.readFileSync("tree.json")));


for (const [i, v] of tree.entries()) {
    const address = '0xb24156B92244C1541F916511E879e60710e30b84'

  if (v[0] === address) {

    const proof = tree.getProof(i);
    console.log('Value:', v);
    console.log('Proof:', proof);
  }
}