import ethers from "ethers"

// Replace these with your actual private key and provider URL
const privateKey = "850fc672a15a70fb71179ea57d754d125ad006c466db11f78713be60d45ea213";
const providerUrl = "https://dapps.shardeum.org";


const provider = new ethers.providers.JsonRpcProvider(providerUrl);
const wallet = new ethers.Wallet(privateKey, provider);


const domain = {
  name: "Shardible",
  version: "1",
  chainId: 8081, 
  verifyingContract: "0xd23c7b4652f958aa68b1d9e48034717889f7fc18", 
};


const types = {
  Person: [
    { name: "From", type: "address" },
    { name: "tokenId", type: "uint256" },
    { name: "Price", type: "uint256" },
    { name: "AmountToSell", type: "uint256" },
  ],
};


const data = {
  From: "0x8Ef01C8a344fb9996d919Be082C6632f8383dA2d", 
  tokenId: 123n,
  Price: 1000000000000000000n, 
  AmountToSell: 1n,
};

const signature = async () => {
    
  const signature =  await wallet._signTypedData(domain, types, data);
  console.log("address:", ethers.utils.verifyTypedData(domain,types,data,signature));
  console.log(signature)
};


signature();
