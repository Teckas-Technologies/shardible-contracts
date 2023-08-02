// SPDX-License-Identifier: UNLICENSED

//@todo: Whether set new creator is necessary

//@todo: Option to change the creator address
pragma solidity ^0.8.13;
import "lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";
import "src/TokenIdentifiers.sol";
import "src/NftOverride.sol";
import "lib/openzeppelin-contracts/contracts/access/AccessControl.sol";
contract wrappedNftV2 is ReentrancyGuard,AccessControl {
    using TokenIdentifiers for uint256;

    SHARDIBLE nftAddress;   

    bytes32 constant OWNER = keccak256("ShardibleMarketplaceOwners");

    mapping(uint256 => bool) private _isPermanentURI;

    struct MintParams{
        address to;
        uint256 id;
        uint256 quantity;
        bytes data;
        address royaltyReceiver;
        //@note: Should be in basis points
        uint96 royaltyFeeNumerator;

    }

    modifier creatorOnly(uint256 _id){
        require(
            _isCreator(_id,msg.sender),
            "Only creator Can Call"
        );
        _;
    }

    modifier supplyCap(uint256 _id,uint256 amountToMint){
        require(
            _supplyCap(_id,amountToMint),
            "Minting will exceed the total supply"
        );
        _;

    }


    modifier onlyImpermanentURI(uint256 id) {
        require(
            !isPermanentURI(id),
            "URI FREEZED"
        );
        _;
    }

    event NewNftMint(address _creator,uint256 _tokenId,uint256 _amount);
    event NftAddressChanged(address _oldAddress,address _newAddress);

    event royaltyUpdate(uint256 _tokenId,uint96 _newFeeNumerator,address _newReceiver);

    event PermanentURI(string  uri,uint256 tokenId);

    //Only the creator can mint the nft 
    function mintNft(MintParams memory _mintingParams) public nonReentrant creatorOnly(_mintingParams.id) supplyCap(_mintingParams.id,_mintingParams.quantity) {
        

        nftAddress.mint(_mintingParams.to,_mintingParams.id,_mintingParams.quantity,_mintingParams.data);


        //Set Token Royalty For the Address
        nftAddress.setTokenRoyalty(_mintingParams.id,_mintingParams.royaltyReceiver,_mintingParams.royaltyFeeNumerator);


        emit NewNftMint(msg.sender,_mintingParams.id,_mintingParams.quantity);


    }

    function setUri(uint256 _tokenId,string memory _tokenURI) public onlyImpermanentURI(_tokenId)creatorOnly(_tokenId){
        nftAddress.setPerTokenUri(_tokenId,_tokenURI);
    }

    function isPermanentURI(uint256 tokenId) public view returns(bool){
        return _isPermanentURI[tokenId];
    }

    function setPermanentURI(uint256 _id, string memory _uri)public creatorOnly(_id) onlyImpermanentURI(_id)

    {
        _setPermanentURI(_id, _uri);
    } 



    //@note: Only the original token creator should be able to update the token address
    function updateTokenRoyalty(uint256 _tokenId,uint96 _newFeeNumerator,address _newRoyaltyReceiver) external creatorOnly(_tokenId){
        nftAddress.setTokenRoyalty(_tokenId,_newRoyaltyReceiver,_newFeeNumerator);
        emit royaltyUpdate(_tokenId,_newFeeNumerator,_newRoyaltyReceiver);

    }

 




    function _isCreator(uint256 id, address caller) internal pure returns(bool){
        address creator_ = id.tokenCreator(); 
        return creator_ == caller;

    }

    function _supplyCap(uint256 id,uint256 amountToMint) internal view returns(bool){
        uint256 maxSupply = id.tokenMaxSupply();
        uint256 currentSupply = nftAddress.totalSupply(id);
        return((currentSupply + amountToMint) <= maxSupply);
    }

    function _setPermanentURI(uint256 _id, string memory _uri)
        internal 
    {
        require(
            bytes(_uri).length > 0,
            "ONLY_VALID_URI"
        );
        _isPermanentURI[_id] = true;
        setUri(_id, _uri);
        emit PermanentURI(_uri, _id);
    }




    //OnlyOwnerShouldCallThis

    function updateNftAddress(address _newNftAddress) external onlyRole(OWNER) {
        SHARDIBLE oldNftAddress = nftAddress;
        nftAddress = SHARDIBLE(_newNftAddress);
        emit NftAddressChanged(address(oldNftAddress),address(nftAddress));
    }


    function setGlobalUri(string memory _GlobalUri) external onlyRole(OWNER) {
        nftAddress.setGlobalURI(_GlobalUri);
    }
     
}
