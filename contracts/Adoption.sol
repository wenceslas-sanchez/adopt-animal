pragma solidity ^0.8.11;

contract Adoption {
    struct Animal {
        string kind;
        uint age;
    }
    uint constant MAX_ANIMAL= 10; // max number of available animals.
    uint constant DOG_PROBA= 60;
    uint8 randNone= 0; // may overflow, this is not an issue
    address[MAX_ANIMAL] private adopters;
    Animal[MAX_ANIMAL] private animals;

    event AdoptAnimalEvent(uint id, address owner);

    function adoptAnimal(uint _petId) public {
        require(_petId>= 0 && _petId < MAX_ANIMAL);
        if (adopters[_petId] == address(0)) {
            animals[_petId]= Animal(
                generateAnimalKind(),
                generateAnimalAge()
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

    function generateAnimalAge() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNone))) % 100;
    }

    function getAdopters() public view returns (address[MAX_ANIMAL] memory) {
        return adopters;
    }

    function getAnimals() public view returns (Animal[MAX_ANIMAL] memory) {
        return animals;
    }

}

