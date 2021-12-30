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
        bool alive;
        animalFeeding.adoptAnimal(0, "Alice");
        (,,,, alive)= animalFeeding.animals(0);
        require(alive, "The new pet should be alive.");
    }

    // Not tested yet, can't mock block.timestamp
    function testPetNotAlive() public {
        uint32 lastFeed;
        bool alive;

        animalFeeding.adoptAnimal(1, "Alice");
        (,,, lastFeed,)= animalFeeding.animals(1);
        //lastFeed= uint32(block.timestamp - 30 days);
        //alive= animalFeeding.isPetAlive(1);
        //require(!alive, "The new pet should not be alive.");
    }

    // Not tested yet, can't mock block.timestamp
    function testFeedAnimalAlive() public {
        // We already have adopted 2 animals {0, 1}

    }

    // Not tested yet, can't mock block.timestamp
    function testFeedAnimalDead() public {
        // We already have adopted 2 animals {0, 1}

    }
}
