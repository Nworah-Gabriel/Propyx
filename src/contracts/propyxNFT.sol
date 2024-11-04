// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PropyxNFT is ERC721, Ownable {
    uint256 public nextTokenId;
    mapping(uint256 => uint256) public propertyPrices;
    mapping(uint256 => bool) public propertyListed;

    constructor() ERC721("PropyxNFT", "PRPX") Ownable(msg.sender){}

    function mintProperty(address to) external onlyOwner {
        _safeMint(to, nextTokenId);
        nextTokenId++;
    }

    function setPrice(uint256 tokenId, uint256 price) external {
        require(ownerOf(tokenId) == msg.sender, "Not the owner");
        propertyPrices[tokenId] = price;
        propertyListed[tokenId] = true;
    }

    function buyProperty(uint256 tokenId) external payable {
        require(propertyListed[tokenId], "Not for sale");
        uint256 price = propertyPrices[tokenId];
        require(msg.value == price, "Incorrect Ether value");

        address seller = ownerOf(tokenId);
        _transfer(seller, msg.sender, tokenId);

        propertyListed[tokenId] = false;
        propertyPrices[tokenId] = 0;

        payable(seller).transfer(msg.value);
    }

    function transferProperty(address to, uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "Not the owner");
        _transfer(msg.sender, to, tokenId);
    }
}
