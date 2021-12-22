pragma solidity ^0.8.11;

contract Adoption {
    address[] public adopters;
    uint petNumber= 0;

    function adopt(uint _petId) public returns (uint) {
        require(_petId > 0 && _petId <= petNumber + 2, "The pet you want to adopt doesn't exist yet.");
        adopters[_petId]= msg.sender;
        petNumber++;
        return _petId;
    }

    /*
     * @dev Public vision of data location adopters.
     */
    function getAdopters() public view returns (address[] memory) {
        return adopters;
    }



}
