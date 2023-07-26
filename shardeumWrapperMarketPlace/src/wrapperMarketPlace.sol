// SPDX-License-Identifier: UNLICENSED

import "lib/openzeppelin-contracts/contracts/access/AccessControl.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC1155/IERC1155.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import "src/Nft.sol";
pragma solidity ^0.8.13;

contract MARKETPLACEWRAPPER is AccessControl  {
    using SafeERC20 for IERC20;

    bytes32 public constant BACKEND = keccak256("BACKEND");
    ERCTOKEN public Nft = ERCTOKEN(0xd1670f6D95c9A8C69925eF3198139de26854eB7c);
    IERC20 public  wrappedShm = IERC20(0x1DAcbaB28Decd115c8AA6F183877C71b942aE406);

    
    constructor ()  {
    _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
  }


    function mintAndTransfer(address seller,address buyer,uint256 id, uint256 Nftamount,uint256 priceAmount,bytes memory data) external onlyRole(BACKEND)
    {
            require(!Nft.exists(id),"Token Id already  exist");
        
            wrappedShm.safeTransferFrom(buyer,seller,priceAmount*Nftamount);

            Nft.mint(buyer,id,Nftamount,data);
            
    }

    function updateNftContract(ERCTOKEN addy) external onlyRole(DEFAULT_ADMIN_ROLE){
        Nft = addy;
    }

    function updateShmContract(IERC20 _wrappedShm) external onlyRole(DEFAULT_ADMIN_ROLE){
        wrappedShm = _wrappedShm;
    }






}
