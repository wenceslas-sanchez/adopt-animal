pragma solidity ^0.8.0;

import {AnimalOwnership} from "./AnimalOwnership.sol";

contract AnimalFeeding is AnimalOwnership {
    uint public coolDown= 7 days;
    uint public foodCost= 0.00000001 ether;

    event AnimalFeed(uint _petId, address _owner);
    event AnimalDead(uint _petId);

    modifier petAlive(uint _petId) {
        require(isPetAlive(_petId), "Your pet is dead...");
        _;
    }

    function isPetAlive(uint _petId) public petIdAssigned(_petId) returns (bool){
        Animal storage animal= animals[_petId];
        if (!animal.alive) {
            return false;
        } else if (animal.lastFeed <= coolDown) {
            animal.alive= false;
            emit AnimalDead(_petId);
            return false;
        }
        return true;
    }

    function setFoodCost(uint _foodCost) external onlyOwner {
        foodCost= _foodCost;
    }

    function setCoolDown(uint _coolDown) external onlyOwner {
        coolDown= _coolDown;
    }

    function feedAnimal(uint _petId) public payable onlyOwnerOf(_petId) petAlive(_petId) {
        require(msg.value == foodCost);
        Animal storage animal= animals[_petId];
        animal.lastFeed= uint32(block.timestamp); // update lastFeed value
        emit AnimalFeed(_petId, msg.sender);
    }
}
