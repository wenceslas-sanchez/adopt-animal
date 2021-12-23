pragma solidity ^0.8.11;

import {AdoptionUtils} from "./AdoptionUtils.sol";

contract Adoption {
    struct Animal {
        string name;
        string kind;
        uint age;
    }
    uint constant maxAnimal= 10; // max number of available animals.
    uint constant dogProba= 60;
    uint8 randNone= 0; // may overflow, this is not an issue
    address[maxAnimal] adopters;
    Animal public animals;

    event AdoptAnimalEvent(uint id, address owner);

    function adoptAnimal(uint _petId) public {
        require(_petId>= 0 && _petId < maxAnimal);
        if (adopters[_petId] == address(0)) {
            adopters[_petId] = msg.sender;
            emit AdoptAnimalEvent(_petId, msg.sender);
        } else {
            revert("This animal already has a home.");
        }
    }

    function generateAnimalKind() private returns (string memory){
        uint proba= uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNone))) % 100;
        randNone++; // can overflow, this is not an issue
        if (proba < dogProba) {
            return "dog";
        } else {
            return "cat";
        }
    }

    function generateAnimalName() private view returns (string memory) {
        return AdoptionUtils.uintToString(uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNone))));
    }

    function generateAnimalAge() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNone))) % 100;
    }

    function getAdopters() public view returns (address[maxAnimal] memory) {
        return adopters;
    }

}

