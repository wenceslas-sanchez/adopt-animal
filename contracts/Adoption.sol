pragma solidity ^0.8.11;

contract Adoption {
    struct Animal {
        string name;
        string kind;
        uint8 age;
        uint32 lastFeed;
    }
    uint constant MAX_ANIMAL= 10; // max number of available animals.
    uint constant DOG_PROBA= 60;
    uint8 randNone= 0; // may overflow, this is not an issue
    address[MAX_ANIMAL] private adopters;
    Animal[MAX_ANIMAL] private animals;

    event AdoptAnimalEvent(uint id, address owner);

    modifier petIdExists(uint _petId) {
        require(_petId>= 0 && _petId < MAX_ANIMAL,
            string(
                abi.encodePacked("There is only ", MAX_ANIMAL,
                " available. Please call ____ to find an available petId")
            )
        );
        _;
    }

    function adoptAnimal(uint _petId, string memory _name) public petIdExists(_petId) {
        if (adopters[_petId] == address(0)) {
            animals[_petId]= Animal(
                _name,
                generateAnimalKind(),
                generateAnimalAge(),
                uint32(now)
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

    function getAvailablePetId() public view returns (uint[] memory) {
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
        return availablePetId;
    }

    function getAdopters() public view returns (address[MAX_ANIMAL] memory) {
        return adopters;
    }

    function getAnimals() public view returns (Animal[MAX_ANIMAL] memory) {
        return animals;
    }

}

