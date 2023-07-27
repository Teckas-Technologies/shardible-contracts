const typedMessage = {
    primaryType: 'Person',
    domain: {
      name: 'Shardible',
      version: '1',
    },
  
    types: {
      EIP712Domain: [
        { name: 'name', type: 'string' },
        { name: 'version', type: 'string' },
        { name: 'chainId', type: 'uint256' },
        { name: 'verifyingContract', type: 'address' },
      ],
      Person: [
        { name: "From", type: "address" },
        { name: "tokenId", type: "uint256" },
        { name: "Price", type: "uint256" },
        { name: "AmountToSell", type: "uint256" },
      ],
     }
  };
  
  module.exports = typedMessage;