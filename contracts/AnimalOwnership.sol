pragma solidity ^0.8.11;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Adoption} from "./Adoption.sol";

contract AnimalOwnership is Adoption, Ownable, ERC721 {
    constructor() ERC721("TestAnimalAdoption", "ANI") {}

    mapping(uint256 => address) animalApprovals;
    bool[] petIdApprovals; // store animalApprovals keys

    modifier onlyOwnerOf(uint256 _petId) {
        require(msg.sender == ownerOf(_petId));
        _;
    }

    function balanceOf(address _owner) public view override returns (uint256) {
        uint256 _balance = 0;
        for (uint256 i = 0; i < MAX_ANIMAL; i++) {
            if (adopters[i] == _owner) {
                _balance++;
            }
        }
        return _balance;
    }

    function ownerOf(uint256 _tokenId)
        public
        view
        override
        petIdExists(_tokenId)
        returns (address)
    {
        return adopters[_tokenId];
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public override {}

    function approve(address _to, uint256 _tokenId)
        public
        override
        onlyOwnerOf(_tokenId)
    {
        animalApprovals[_tokenId] = _to;
        petIdApprovals[_tokenId] = true;
        emit Approval(msg.sender, _to, _tokenId);
    }

    function getApproved(uint256 _tokenId)
        public
        view
        override
        returns (address _operator)
    {
        _operator = address(0);
        for (uint8 i = 0; i < petIdApprovals.length + 1; i++) {
            if (petIdApprovals[i]) {
                _operator = animalApprovals[_tokenId];
                break;
            }
        }
    }

    function setApprovalForAll(address _operator, bool _approved)
        public
        override
    {}

    function isApprovedForAll(address _owner, address _operator)
        public
        view
        override
        returns (bool)
    {
        return false;
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes memory _data
    ) public override {}
}
