pragma solidity ^0.8.0;

import {AnimalOwnership} from "./AnimalOwnership.sol";

contract AnimalFeeding is AnimalOwnership {
    uint constant coolDown= 7 days;
    uint foodCost= 0.00000001 ether;

    event AnimalFeed(uint _petId, address _owner);
    event AnimalDead(uint _petId);

    modifier isPetAlive(uint _petId) {
        require(animals[_petId].lastFeed <= coolDown, "Your animal is dead :'(");
        emit AnimalDead(_petId);
        _;
    }

    function feedAnimal(uint _petId, address _owner) public payable onlyOwnerOf(_petId) isPetAlive(_petId) {
        require(msg.value == foodCost);
        Animal animal= animals[_petId];
        animal.lastFeed= uint32(now); // update lastFeed value
        emit AnimalFeed(_petId, msg.sender);
    }

    function changeFoodCost(uint _newFoodCost) private onlyOwner {
        foodCost= _newFoodCost;
    }
}
