// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Propyx is ERC721URIStorage, Ownable, ReentrancyGuard {
    uint256 public nextTokenId;
    mapping(uint256 => uint256) public assetPrices; // Token ID => Price
    mapping(uint256 => address) public assetOwners; // Token ID => Owner

    event AssetTokenized(uint256 indexed tokenId, address indexed owner, uint256 price, string tokenURI);
    event AssetPurchased(uint256 indexed tokenId, address indexed buyer, address indexed seller, uint256 price);

    constructor() ERC721("Propyx", "PPX") Ownable(msg.sender){}

    /**
     * @notice Tokenize a real estate asset by creating an NFT.
     * @param price The sale price of the asset.
     * @param tokenURI Metadata URI describing the asset.
     */
    function tokenizeAsset(uint256 price, string memory tokenURI) external onlyOwner nonReentrant {
        require(price > 0, "Price must be greater than zero");

        uint256 tokenId = nextTokenId;
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);

        assetPrices[tokenId] = price;
        assetOwners[tokenId] = msg.sender;

        emit AssetTokenized(tokenId, msg.sender, price, tokenURI);

        nextTokenId++;
    }

    /**
     * @notice Purchase an asset from its owner.
     * @param tokenId The ID of the asset token to buy.
     */
    function buyAsset(uint256 tokenId) external payable nonReentrant {
        address seller = assetOwners[tokenId];
        uint256 price = assetPrices[tokenId];

        require(msg.sender != seller, "Cannot buy your own asset");
        require(msg.value == price, "Incorrect payment amount");
        require(ownerOf(tokenId) != address(0), "Token does not exist");

        // Transfer payment to the seller
        (bool success, ) = seller.call{value: msg.value}("");
        require(success, "Payment transfer failed");

        // Transfer NFT ownership from seller to buyer
        _transfer(seller, msg.sender, tokenId);

        // Update asset ownership record
        assetOwners[tokenId] = msg.sender;
        assetPrices[tokenId] = 0; // Mark as not for sale by default after purchase

        emit AssetPurchased(tokenId, msg.sender, seller, price);
    }

    /**
     * @notice Set the price of an asset (only by the asset owner).
     * @param tokenId The ID of the asset token.
     * @param price The sale price to set for the asset.
     */
    function setAssetPrice(uint256 tokenId, uint256 price) external {
        require(ownerOf(tokenId) == msg.sender, "Only asset owner can set price");
        require(price > 0, "Price must be greater than zero");

        assetPrices[tokenId] = price;
    }

    /**
     * @notice Withdraw contract balance to the owner's address.
     */
    function withdrawBalance() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");

        (bool success, ) = owner().call{value: balance}("");
        require(success, "Withdrawal failed");
    }

    /**
     * @notice Get all listed properties with their details.
     * @return tokenIds The list of token IDs.
     * @return owners The list of owner addresses.
     * @return prices The list of asset prices.
     */
    function getListedProperties() external view returns (uint256[] memory tokenIds, address[] memory owners, uint256[] memory prices) {
        uint256 totalTokens = nextTokenId;
        uint256 count = 0;

        for (uint256 i = 0; i < totalTokens; i++) {
            if (ownerOf(i) != 0x0000000000000000000000000000000000000000 && assetPrices[i] > 0) {
                count++;
            }
        }

        tokenIds = new uint256[](count);
        owners = new address[](count);
        prices = new uint256[](count);

        uint256 index = 0;
        for (uint256 i = 0; i < totalTokens; i++) {
            if (ownerOf(i) != 0x0000000000000000000000000000000000000000 && assetPrices[i] > 0) {
                tokenIds[index] = i;
                owners[index] = ownerOf(i);
                prices[index] = assetPrices[i];
                index++;
            }
        }
    }

    // Fallback function to receive Ether if needed
    receive() external payable {}
    fallback() external payable {}
}
