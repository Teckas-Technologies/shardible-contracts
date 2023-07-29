import { StandardMerkleTree } from "@openzeppelin/merkle-tree";
import fs from "fs";
import data from "./NftOwnerdata.json" assert {type:'json'}






async function main() {
    const tree = StandardMerkleTree.of(data, ["address", "uint256[]"]);
    console.log('Merkle Root:', tree.root);
    fs.writeFileSync("tree.json", JSON.stringify(tree.dump()));
}



main()

