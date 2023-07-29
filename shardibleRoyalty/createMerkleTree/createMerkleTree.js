import { StandardMerkleTree } from "@openzeppelin/merkle-tree";
import fs from "fs";
import data from "./NftOwnerdata.json" assert {type:'json'}






async function main() {
    const tree = StandardMerkleTree.of(data, ["address", "uint256[]"]);


    console.log('Merkle Root:', tree.root);
    fs.writeFileSync("tree.json", JSON.stringify(tree.dump()));
}



main()

//0x8802e8e27ae70511103150df4b07676fecb729815ba479305c7abaaf54419dae