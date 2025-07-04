// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VeriSkillNFT is ERC721URIStorage, Ownable {
    uint256 public nextTokenId;
    mapping(uint256 => string) public skillNames;

    constructor(address initialOwner) ERC721("Verisoul Skill", "VSKILL") {
        _transferOwnership(initialOwner); // Correct way to initialize Ownable in v4.9
    }

    function mintSkill(address to, string memory skillName, string memory tokenURI) external onlyOwner {
        uint256 tokenId = nextTokenId;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
        skillNames[tokenId] = skillName;
        nextTokenId++;
    }

    // Soulbound: Disable transfers (but allow minting and burning)
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override {
        require(from == address(0) || to == address(0), "Soulbound: Transfer disabled");
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // Optional burn function (self-revocation)
    function burn(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "Only token owner can burn");
        _burn(tokenId);
    }
}
