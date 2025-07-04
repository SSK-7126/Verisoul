// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/VeriSkillNFT.sol";

contract VeriSkillNFTTest is Test {
    VeriSkillNFT public nft;
    address alice = address(0x1);
    address bob = address(0x2);

 function setUp() public {
    nft = new VeriSkillNFT(address(this)); // deploy with test contract as owner
}



    function testMintSkill() public {
        nft.mintSkill(alice, "Solidity", "ipfs://sample-skill-uri");
        assertEq(nft.ownerOf(0), alice);
        assertEq(nft.skillNames(0), "Solidity");
    }

    function testTransferFails() public {
        nft.mintSkill(alice, "Solidity", "ipfs://sample-skill-uri");

        // Simulate Alice trying to transfer the token to Bob
        vm.prank(alice);
        vm.expectRevert("Soulbound: Transfer disabled");
        nft.transferFrom(alice, bob, 0);
    }

    function testBurnSkill() public {
        nft.mintSkill(alice, "Solidity", "ipfs://sample-skill-uri");

        // Burn by the owner (Alice)
        vm.startPrank(alice);
        nft.burn(0);
        vm.stopPrank();

        // Token should no longer exist
        vm.expectRevert();
        nft.ownerOf(0);
    }
}