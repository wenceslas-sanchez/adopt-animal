pragma solidity ^0.8.11;

abstract contract Game {
    struct GameInstance {
        address playerOne;
        address playerTwo;
        uint8 turn;
    }
}
