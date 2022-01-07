pragma solidity ^0.8.11;

contract Adoption {
    struct Animal {
        string name;
        string kind;
        uint8 age;
        uint32 lastFeed;
        bool alive;
    }
    uint256 constant MAX_ANIMAL = 10; // max number of available animals.
    uint256 constant DOG_PROBA = 60;
    uint256 public coolDown = 7 days;
    uint8 constant adoptingCost = 0.00001 ether; // will never change
    uint8 randNone = 0; // may overflow, this is not an issue
    address[MAX_ANIMAL] public adopters;
    Animal[MAX_ANIMAL] public animals;

    event AdoptAnimalEvent(uint256 id, address owner);

    modifier petIdExists(uint256 _petId) {
        _petExist(_petId);
        _;
    }

    modifier petIdAssigned(uint256 _petId) {
        _petExist(_petId);
        _petAssigned(_petId);
        _;
    }

    function _petExist(uint256 _petId) public pure {
        require(
            _petId >= 0 && _petId < MAX_ANIMAL,
            string(
                abi.encodePacked(
                    "There is only ",
                    MAX_ANIMAL,
                    " available. Please call getAvailablePetId method to find an available petId."
                )
            )
        );
    }

    function _petAssigned(uint256 _petId) internal view {
        bool assigned = true;
        uint256[] memory allAvailable;
        uint256 numAvailable;
        (allAvailable, numAvailable) = getAvailablePetId();

        for (uint256 i = 0; i < numAvailable; i++) {
            if (_petId == allAvailable[i]) {
                assigned = false;
                break;
            }
        }
        require(assigned, "This pet is not assigned to a user.");
    }

    function getAvailablePetId()
        public
        view
        returns (uint256[] memory, uint256)
    {
        address nullAddress = address(0);
        uint256[] memory allPetId = new uint256[](MAX_ANIMAL);
        uint256 j = 0;
        for (uint256 i = 0; i < MAX_ANIMAL; i++) {
            if (adopters[i] == nullAddress) {
                allPetId[j] = i;
                j++;
            }
        }
        uint256[] memory availablePetId = new uint256[](j);
        for (uint256 i = 0; i < j; i++) {
            availablePetId[i] = allPetId[i];
        }
        return (availablePetId, j);
    }

    function adoptAnimal(uint256 _petId, string memory _name)
        public
        petIdExists(_petId)
    {
        if (adopters[_petId] == address(0)) {
            animals[_petId] = Animal(
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

    function generateAnimalKind() public returns (string memory kind) {
        uint256 proba = uint256(
            keccak256(abi.encodePacked(block.timestamp, msg.sender, randNone))
        ) % 100;
        randNone++; // can overflow, this is not an issue
        if (proba < DOG_PROBA) {
            kind = "dog";
        } else {
            kind = "cat";
        }
        return kind;
    }

    function generateAnimalAge() public view returns (uint8) {
        return
            uint8(
                uint256(
                    keccak256(
                        abi.encodePacked(block.timestamp, msg.sender, randNone)
                    )
                )
            ) % 100;
    }
}
