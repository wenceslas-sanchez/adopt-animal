pragma solidity ^0.8.11;

import {Assert} from "truffle/Assert.sol";
import {DeployedAddresses} from "truffle/DeployedAddresses.sol";
import {AnimalFeeding} from "../contracts/AnimalFeeding.sol";


contract TestAnimalFeeding {
    uint constant MAX_ANIMAL= 10; // max number of available animals.
    AnimalFeeding animalFeeding= AnimalFeeding(DeployedAddresses.AnimalFeeding());

    function _setCoolDown() public {
        animalFeeding.setCoolDown(1 days);
    }

    function testSetCoolDownNotWork() public {
        (bool r, ) = address(this).call(abi.encodePacked(this._setCoolDown.selector));
        Assert.isFalse(r, "Should not change cooldown state variable if not called by owner.");
    }

    function _setFoodCost() public {
        animalFeeding.setFoodCost(1 ether);
    }

    function testSetFoodCostNotWork() public {
        (bool r, ) = address(this).call(abi.encodePacked(this._setFoodCost.selector));
        Assert.isFalse(r, "Should not change food cost state variable if not called by owner.");
    }

    function testPetAlive() public {
        AnimalFeeding.Animal memory animalAlice;
        uint32 lastFeed; bool alive;

        require(!animalAlice.alive, "No pet adopted yet. So the non-pet 'should be dead' because bool is null.");

        animalFeeding.adoptAnimal(0, "Alice");
        (,,, lastFeed, alive)= animalFeeding.animals(0);
        animalAlice.lastFeed= lastFeed;
        animalAlice.alive= alive;
        require(animalAlice.alive, "The new pet should be alive.");
    }

    function testPetNotAlive() public {
        AnimalFeeding.Animal memory animalAlice;
        uint32 lastFeed;

        animalFeeding.adoptAnimal(1, "Alice");
        animalAlice.alive= true;
        animalAlice.lastFeed= uint32(block.timestamp - 7 days);
        //animalFeeding.isPetAlive(1);
        //require(!animalAlice.alive, "The new pet should not be alive.");
    }

}
