pragma solidity ^0.8.11;

import {AnimalOwnership} from "./AnimalOwnership.sol";

contract AnimalFeeding is AnimalOwnership {
    uint256 public foodCost = 0.00000001 ether;

    event AnimalFeed(uint256 _petId, address _owner);
    event AnimalDead(uint256 _petId);

    modifier petAlive(uint256 _petId) {
        require(isPetAlive(_petId), "Your pet is dead...");
        _;
    }

    function isPetAlive(uint256 _petId)
        public
        petIdAssigned(_petId)
        returns (bool)
    {
        Animal storage animal = animals[_petId];
        if (!animal.alive) {
            return false;
        } else if (animal.lastFeed <= uint32(block.timestamp)) {
            animal.alive = false;
            emit AnimalDead(_petId);
            return false;
        }
        return true;
    }

    function setFoodCost(uint256 _foodCost) external onlyOwner {
        foodCost = _foodCost;
    }

    function setCoolDown(uint256 _coolDown) external onlyOwner {
        coolDown = _coolDown;
    }

    function feedAnimal(uint256 _petId)
        public
        payable
        onlyOwnerOf(_petId)
        petAlive(_petId)
    {
        require(msg.value == foodCost);
        Animal storage animal = animals[_petId];
        animal.lastFeed = uint32(block.timestamp + coolDown); // update lastFeed value
        emit AnimalFeed(_petId, msg.sender);
    }
}
