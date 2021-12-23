pragma solidity ^0.8.11;

contract Adoption {
    struct Animal {
        string kind;
        uint age;
    }
    uint constant maxAnimal= 10; // max number of available animals.
    uint constant dogProba= 60;
    uint8 randNone= 0; // may overflow, this is not an issue
    address[maxAnimal] private adopters;
    Animal[maxAnimal] private animals;

    event AdoptAnimalEvent(uint id, address owner);

    function adoptAnimal(uint _petId) public {
        require(_petId>= 0 && _petId < maxAnimal);
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
        if (proba < dogProba) {
            kind= "dog";
        } else {
            kind= "cat";
        }
        return kind;
    }

    function generateAnimalAge() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNone))) % 100;
    }

    function getAdopters() public view returns (address[maxAnimal] memory) {
        return adopters;
    }

    function getAnimals() public view returns (Animal[maxAnimal] memory) {
        return animals;
    }

}

