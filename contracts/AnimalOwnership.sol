pragma solidity ^0.8.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Adoption} from "./Adoption.sol";

contract AnimalOwnership is Adoption, Ownable, ERC721 {
    constructor() ERC721("TestAnimalAdoption", "ANI"){
    }

    modifier onlyOwnerOf(uint _petId) {
        require(msg.sender == ownerOf(_petId));
        _;
    }

    function balanceOf(address _owner) public override view returns (uint256 _balance) {
        return 1;
    }

    function ownerOf(uint256 _tokenId) public override view petIdExists(_tokenId) returns (address) {
        return adopters[_tokenId];
    }

    function transferFrom(address _from, address _to, uint _tokenId) public override {

    }

    function approve(address _to, uint256 _tokenId) public override {

    }

    function getApproved(uint256 _tokenId) public view override returns (address _operator) {
        return address(0);
    }

    function setApprovalForAll(address _operator, bool _approved) public override {

    }

    function isApprovedForAll(address _owner, address _operator) public view override returns (bool) {
        return false;
    }

    function safeTransferFrom(address _from, address _to, uint _tokenId) public override {

    }

    function safeTransferFrom(address _from, address _to, uint _tokenId, bytes memory _data) public override {

    }

}
