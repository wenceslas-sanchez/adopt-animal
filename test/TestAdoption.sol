pragma solidity ^0.8.11;

import {Assert} from "truffle/Assert.sol";
import {DeployedAddresses} from "truffle/DeployedAddresses.sol";
import {Adoption} from "../contracts/Adoption.sol";

contract TestAdoption {
    Adoption adoption= Adoption(DeployedAddresses.Adoption());
    uint expectedPetId = 1;
    address expectedAdopter = address(this);
    event TestEven(uint);

    // Test adopt function.
    function testUserAdopt() public {
        uint resultId = adoption.adopt(expectedPetId);
        emit TestEven(resultId);
        Assert.equal(resultId, expectedPetId, "Expected");
    }
}
