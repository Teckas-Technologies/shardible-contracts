// SPDX-License-Identifier: UNLICENSED


import "lib/openzeppelin-contracts/contracts/access/AccessControl.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

pragma solidity ^0.8.13;


contract ERCTOKEN is ERC1155Supply,AccessControl {

    bytes32 public constant MINTER = keccak256("MINTER");
  constructor ()  ERC1155(""){
    _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
  }
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, AccessControl) returns (bool) {
        return true;
    }

    function mint(address to, uint256 id, uint256 amount, bytes memory data) external onlyRole(MINTER) returns(bool){
        super._mint(to,id,amount,data);

    }



}


