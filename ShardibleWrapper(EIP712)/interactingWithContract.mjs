import { ethers } from "ethers";
import contractABI from "/home/deeps/eip712/out/eip712test.sol/eip712Test.json" assert { type: "json" };;

async function main() {
  // Step 1: Connect to the Ethereum network (Rinkeby testnet)
  const provider = new ethers.providers.JsonRpcProvider("https://eth-goerli.g.alchemy.com/v2/hScjvrhZxMw9z1xjg03SCGHK8aRN8K9N");

  // Step 2: Load the contract
  const contractAddress = "0xd23c7b4652f958aa68b1d9e48034717889f7fc18";
  const contract = new ethers.Contract(contractAddress, contractABI.abi, provider);

  try {
    const Person = {
        From: "0x8Ef01C8a344fb9996d919Be082C6632f8383dA2d",
        tokenId: 123n,
        Price: 1000000000000000000n, 
        AmountToSell: 1n,
    }
    const SignedPerson = {
      message :Person,
        signature: "0xcc516bd87edfca5c4514ca213d58e6bd38749a10fd13e948065c77fbaf4bb9bc21a9489398693febbf0b81527449053d33bf3478d3617ae5de81f1fb820ac1751c",
        signer: "0x0000000000000000000000000000000000000000"
    }    
    const result = await contract.verifySignedPerson(SignedPerson);

    if (result === Person.From){
      console.log("Success")
    }
    console.log("Result:", result);
  } catch (error) {
    console.error("Error:", error);
  }
}

main();
