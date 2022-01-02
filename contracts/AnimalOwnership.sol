pragma solidity ^0.8.11;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Adoption} from "./Adoption.sol";

contract AnimalOwnership is Adoption, Ownable, ERC721 {
    constructor() ERC721("TestAnimalAdoption", "ANI"){
    }

    mapping (uint => address) animalApprovals;
    int8[MAX_ANIMAL] petIdApprovals; // store animalApprovals keys

    modifier onlyOwnerOf(uint _petId) {
        require(msg.sender == ownerOf(_petId));
        _;
    }

    // From https://ethereum.stackexchange.com/questions/1527/how-to-delete-an-element-at-a-certain-index-in-an-array/1528
    function _burn(uint index) internal {
        require(index < array.length);
        array[index] = array[array.length-1];
        array.pop();
    }

    function balanceOf(address _owner) public override view returns (uint) {
        uint _balance= 0;
        for (uint i= 0; i < MAX_ANIMAL; i++) {
            if (adopters[i] == _owner) {
                _balance++;
            }
        }
        return _balance;
    }

    function ownerOf(uint256 _tokenId) public override view petIdExists(_tokenId) returns (address) {
        return adopters[_tokenId];
    }

    function transferFrom(address _from, address _to, uint _tokenId) public override {
    }

    function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) override {
        animalApprovals[_tokenId]= _to;
        petIdApprovals.push(uint8(_tokenId));
        Approval(msg.sender, _to, _tokenId);
    }

    function getApproved(uint256 _tokenId) public view override returns (address _operator) {
        _operator= address(0);
        for (uint8 i= 0; i< petIdApprovals.length + 1; i++) {
            if (petIdApprovals[i] == uint8(_tokenId)) {
                _operator= animalApprovals[_tokenId];
                break;
            }
        }
    }

    function setApprovalForAll(address _operator, bool _approved) public override {

    }

    function isApprovedForAll(address _owner, address _operator) public view override returns (bool) {

        return false;
    }

    function safeTransferFrom(address _from, address _to, uint _tokenId, bytes memory _data) public override {

    }

}
