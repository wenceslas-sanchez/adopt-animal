pragma solidity ^0.8.11;

import {Assert} from "truffle/Assert.sol";
import {DeployedAddresses} from "truffle/DeployedAddresses.sol";
import {Adoption} from "../contracts/Adoption.sol";

contract TestAdoption {
    Adoption adoption= Adoption(DeployedAddresses.Adoption());
}
