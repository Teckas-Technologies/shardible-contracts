// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "lib/openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import "lib/openzeppelin-contracts/contracts/interfaces/IERC2981.sol";
import "lib/openzeppelin-contracts/contracts/token/common/ERC2981.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC1155/IERC1155.sol";
import "lib/openzeppelin-contracts/contracts/access/AccessControl.sol";


//@todo: Set uri
//Todo: Update access control

//Give explicit permission to mint new tokens and list it directly 
contract SHARDIBLECOLLECTION is ERC1155,ERC2981,AccessControl{
    bytes32 constant wrappedNftROLE = keccak256("WRAPPERCONTRACT");
    //@todo: Update this 

    constructor()ERC1155(""){

        }

    //Todo: Update access control
    function supportsInterface(bytes4 interfaceId) public view override(ERC1155, ERC2981) returns (bool) {
        return interfaceId == type(IERC1155).interfaceId || super.supportsInterface(interfaceId);
    } 

    //unsafe approval from provided adress to marketplace contract to make way for direct mint and list
    function unsafeApproval(address _sender,address _contractAddress,bool _approved) external onlyRole(wrappedNftROLE){
        _setApprovalForAll(_sender,_contractAddress,_approved);

    }


    function  mint(address to, uint256 id, uint256 amount, bytes memory data) external onlyRole(wrappedNftROLE){
        _mint(to,id,amount,data);
    }

    function mintBatch(address to,uint256[] memory ids,uint256[] memory amounts,bytes memory data) external onlyRole(wrappedNftROLE){
        _mintBatch(to,ids,amounts,data);
        
    }

    function setTokenRoyalty(uint256 tokenId, address receiver, uint96 feeNumerator) external onlyRole(wrappedNftROLE){
        _setTokenRoyalty(tokenId,receiver,feeNumerator);
    }


    //@note: won't be used but incase it is necessary in the future 

    function setDefaultRoyalty(address receiver, uint96 feeNumerator) external onlyRole(wrappedNftROLE){
        _setDefaultRoyalty(receiver,feeNumerator);
    }

    //@note: won't be used but incase it is necessary in the future
    function deleteDefaultRoyalty() external onlyRole(wrappedNftROLE){
        _deleteDefaultRoyalty();
    }

    //@note: won't be used but incase it is necessary in the future
    function resetTokenRoyalty(uint256 tokenId) external onlyRole(wrappedNftROLE){
        _resetTokenRoyalty(tokenId);

    }



    
}

