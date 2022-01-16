pragma solidity ^0.8.11;

import {Assert} from "truffle/Assert.sol";
import {DeployedAddresses} from "truffle/DeployedAddresses.sol";
import {AnimalFeeding} from "../contracts/AnimalFeeding.sol";

contract TestAdoption {
    // defined in Adoption contract
    uint256 constant MAX_ANIMAL = 10; // max number of available animals.
    // Instantiate global contract
    AnimalFeeding adoption = AnimalFeeding(DeployedAddresses.AnimalFeeding());

    function testAdoptAnimal() public {
        // Before adoption, adopters is full fo null address
        address[] memory expectedAdopters = new address[](MAX_ANIMAL);

        for (uint256 i = 0; i < MAX_ANIMAL; i++) {
            Assert.equal(
                address(0),
                adoption.adopters(i),
                "Should only contain null addresses."
            );
        }
        // After adoption, there should be one adopter address.
        adoption.adoptAnimal(0, "Alice");
        expectedAdopters[0] = address(this);
        Assert.equal(
            address(this),
            adoption.adopters(0),
            "First pet should have an owner."
        );
    }

    // For testAdoptAnimalAlreadyAdopted method only
    function raiseAdoptAnimalAlreadyAdopted() public {
        // raise an error if called after adoption.adoptAnimal(1).
        adoption.adoptAnimal(1, "Bob");
    }

    function testAdoptAnimalAlreadyAdopted() public {
        bool r;
        // Once called should work
        adoption.adoptAnimal(1, "Bob");
        // Again for same _petId=1 should not work
        (r, ) = address(this).call(
            abi.encodePacked(this.raiseAdoptAnimalAlreadyAdopted.selector)
        );
        Assert.isFalse(r, "Should not adopt same _petId twice.");
    }

    function testGetAvailablePetId() public {
        uint256[] memory resultAvailablePetId;
        uint256 length;
        adoption.adoptAnimal(2, "Alice");
        adoption.adoptAnimal(3, "Alice");
        adoption.adoptAnimal(4, "Alice");
        adoption.adoptAnimal(5, "Alice");
        adoption.adoptAnimal(6, "Alice");
        adoption.adoptAnimal(7, "Alice");
        adoption.adoptAnimal(8, "Alice");
        (resultAvailablePetId, length) = adoption.getAvailablePetId();
        Assert.equal(length, 1, "Should stay only one pet.");
        Assert.equal(resultAvailablePetId[0], 9, "Should stay the 10-th pet.");
    }
}
