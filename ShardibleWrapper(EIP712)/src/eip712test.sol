// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol";
import "TypesFile.sol";
contract eip712Test is EIP712Decoder{

    bytes32 constant EIP712DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");

    struct Identity {
        address from;
        uint256 tokenId;
        uint256 Price;
        uint256 AmountToSell;
    }
    
    constructor(){

    }
function getEIP712DomainHash(string memory contractName, string memory version, uint256 chainId, address verifyingContract) public pure returns (bytes32) {
    bytes memory encoded = abi.encode(
      EIP712DOMAIN_TYPEHASH,
      keccak256(bytes(contractName)),
      keccak256(bytes(version)),
      chainId,
      verifyingContract
    );
    return keccak256(encoded);
  }

  function getDomainHash () public view override returns (bytes32){
    return(getEIP712DomainHash("Shardible","1",8081,address(this)));
  }


}
