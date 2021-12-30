pragma solidity ^0.8.11;

contract Adoption {
    struct Animal {
        string name;
        string kind;
        uint8 age;
        uint32 lastFeed;
        bool alive;
    }
    uint constant MAX_ANIMAL= 10; // max number of available animals.
    uint constant DOG_PROBA= 60;
    uint public coolDown= 7 days;
    uint8 randNone= 0; // may overflow, this is not an issue
    address[MAX_ANIMAL] public adopters;
    Animal[MAX_ANIMAL] public animals;

    event AdoptAnimalEvent(uint id, address owner);

    modifier petIdExists(uint _petId) {
        _petExist(_petId);
        _;
    }

    modifier petIdAssigned(uint _petId) {
        _petExist(_petId);
        _petAssigned(_petId);
        _;
    }

    function _petExist(uint _petId) public pure {
        require(_petId >= 0 && _petId < MAX_ANIMAL,
            string(
                abi.encodePacked("There is only ", MAX_ANIMAL,
                " available. Please call getAvailablePetId method to find an available petId.")
            )
        );
    }

    function _petAssigned(uint _petId) internal view {
        bool assigned= true;
        uint[] memory allAvailable;
        uint numAvailable;
        (allAvailable, numAvailable)= getAvailablePetId();

        for (uint i= 0; i < numAvailable; i++) {
            if (_petId == allAvailable[i]) {
                assigned= false;
                break;
            }
        }
        require(assigned, "This pet is not assigned to a user.");
    }

    function getAvailablePetId() public view returns (uint[] memory, uint) {
        address nullAddress= address(0);
        uint[] memory allPetId= new uint[](MAX_ANIMAL);
        uint j= 0;
        for (uint i = 0; i < MAX_ANIMAL; i++) {
            if (adopters[i] == nullAddress) {
                allPetId[j]= i;
                j++;
            }
        }
        uint[] memory availablePetId= new uint[](j);
        for (uint i = 0; i < j; i++) {
            availablePetId[i]= allPetId[i];
        }
        return (availablePetId, j);
    }

    function adoptAnimal(uint _petId, string memory _name) public petIdExists(_petId) {
        if (adopters[_petId] == address(0)) {
            animals[_petId]= Animal(
                _name,
                generateAnimalKind(),
                generateAnimalAge(),
                uint32(block.timestamp + coolDown),
                true
            );
            adopters[_petId] = msg.sender;
            emit AdoptAnimalEvent(_petId, msg.sender);
        } else {
            revert("This animal already has a home.");
        }
    }

    function generateAnimalKind() public returns (string memory kind){
        uint proba= uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNone))) % 100;
        randNone++; // can overflow, this is not an issue
        if (proba < DOG_PROBA) {
            kind= "dog";
        } else {
            kind= "cat";
        }
        return kind;
    }

    function generateAnimalAge() public view returns (uint8) {
        return uint8(uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNone)))) % 100;
    }

}