pragma solidity ^0.8.11;

import {Assert} from "truffle/Assert.sol";
import {DeployedAddresses} from "truffle/DeployedAddresses.sol";
import {Adoption} from "../contracts/Adoption.sol";

contract TestAdoption {
    // defined in Adoption contract
    uint constant MAX_ANIMAL= 10; // max number of available animals.
    // Instantiate contract
    Adoption adoption= Adoption(DeployedAddresses.Adoption());

    function testAdoptAnimal() public {
        // Before adoption, adopters is full fo null address
        address[] memory expectedAdopters= new address[](MAX_ANIMAL);
        address[MAX_ANIMAL] memory resultAdopters;

        resultAdopters= adoption.getAdopters();
        for (uint i= 0; i < MAX_ANIMAL; i++) {
            Assert.equal(address(0), resultAdopters[i],
                "Should only contain null addresses."
            );
        }
        // After adoption, there should be one adopter address.
        adoption.adoptAnimal(0);
        resultAdopters= adoption.getAdopters();
        expectedAdopters[0]= address(this);
        Assert.equal(address(this), resultAdopters[0],
            "First pet should have an owner."
        );
    }

    // For testAdoptAnimalAlreadyAdopted method only
    function raiseAdoptAnimalAlreadyAdopted() public {
        // raise an error if called after adoption.adoptAnimal(1).
        adoption.adoptAnimal(1);
    }

    function testAdoptAnimalAlreadyAdopted() public {
        bool r;
        // Once called should work
        adoption.adoptAnimal(1);
        // Again for same _petId=1 should not work
        (r, ) = address(this).call(abi.encodePacked(this.raiseAdoptAnimalAlreadyAdopted.selector));
        Assert.isFalse(r, "Should not adopt same _petId twice.");
    }
}
