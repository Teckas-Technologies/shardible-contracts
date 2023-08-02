// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "lib/openzeppelin-contracts/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "lib/openzeppelin-contracts/contracts/interfaces/IERC2981.sol";
import "lib/openzeppelin-contracts/contracts/token/common/ERC2981.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC1155/IERC1155.sol";
import "lib/openzeppelin-contracts/contracts/access/AccessControl.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";
import "lib/openzeppelin-contracts/contracts/utils/Strings.sol";


//Todo: Update supportsInterface control

//Give explicit permission to mint new tokens and list it directly 
contract SHARDIBLE is ERC1155Supply,ERC2981,AccessControl{
    bytes32 constant wrappedNftROLE = keccak256("WRAPPERCONTRACT");

    using Strings for uint256;

    string private _baseURI = "";

    mapping(uint256 => string) private _tokenURIs;

    constructor()ERC1155(""){

    }

    //Todo: Update the ovveride currently unsafe
    function supportsInterface(bytes4 interfaceId) public view override(ERC1155, ERC2981,AccessControl) returns (bool) {
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


    function uri(uint256 tokenId) public view  override returns (string memory) {
        string memory tokenURI = _tokenURIs[tokenId];

        // If token URI is set, concatenate base URI and tokenURI (via abi.encodePacked).
        return bytes(tokenURI).length > 0 ? string(abi.encodePacked(_baseURI, tokenURI)) : super.uri(tokenId);
    }


    function setPerTokenUri(uint256 tokenId,string memory tokenURI) external onlyRole(wrappedNftROLE){
        _setURI(tokenId,tokenURI);
    }

    function _setURI(uint256 tokenId, string memory tokenURI) internal virtual {
        _tokenURIs[tokenId] = tokenURI;
        emit URI(uri(tokenId), tokenId);
    }

    //Wom't be used but just incase
    function setGlobalURI(string memory globalURI) external onlyRole(wrappedNftROLE){
        _setURI(globalURI);
    }






    
}

