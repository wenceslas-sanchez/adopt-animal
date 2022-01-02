pragma solidity ^0.8.11;

import {Game} from "./Game.sol";

contract Sudoku is Game {
    // 0 if not played yet, 1 for first player, 4 for second player
    uint8 constant frameSize= 3;
    uint8[2] playerNumber= [uint8(1), uint8(4)];
    uint8[2] playerScoreWin= [uint8(3), uint8(12)];


    function generateGameFrame() public pure returns (uint8[frameSize][frameSize] memory) {
        uint8[frameSize][frameSize] memory frame;

        return frame;
    }

    // Given (x, y), set value to frame
    function _action(uint8[2] memory _coord, uint8[frameSize][frameSize] memory _frame, uint _player) public view
    returns (uint8[frameSize][frameSize] memory) {
        _frame[_coord[0]][_coord[1]]= playerNumber[_player];

        return _frame;
    }

    function check(uint8[frameSize][frameSize] memory _frame, uint _player) public view returns (bool) {
        bool _iswin= false;
        for (uint8 i= 0; i < frameSize; i++) {
            uint8 h= 0;
            uint8 v= 0;
            for (uint8 j= 0; j < frameSize; j++) {
                // check horizontal
                h += _frame[i][j];
                // check vertical
                v += _frame[j][i];
                // TODO check diag (both)
            }
            if (h == playerScoreWin[_player] || v == playerScoreWin[_player]) {
                _iswin= true;
            }
        }

        return _iswin;
    }
}
