pragma solidity ^0.8.11;

import {Game} from "./Game.sol";

contract NoughtsCrosses is Game {
    // 0 if not played yet, 1 for first player, 4 for second player
    uint8 constant frameSize = 3;
    uint8[2] playerNumber = [uint8(1), uint8(4)];
    uint8[2] playerScoreWin = [uint8(3), uint8(12)];

    function generateGameFrame()
        public
        pure
        returns (uint8[frameSize][frameSize] memory)
    {
        uint8[frameSize][frameSize] memory frame;

        return frame;
    }

    // Given (x, y), set value to frame
    function _action(
        uint8[2] memory _coord,
        uint8[frameSize][frameSize] memory _frame,
        uint256 _player
    ) public view returns (uint8[frameSize][frameSize] memory) {
        _frame[_coord[0]][_coord[1]] = playerNumber[_player];

        return _frame;
    }

    function _abs8(int8 x) internal pure returns (uint8 y) {
        if (x < 0) {
            y = uint8(-x);
        } else {
            y = uint8(x);
        }
        return y;
    }

    // TODO: performance optimisation
    function checkWinner(
        uint8[frameSize][frameSize] memory _frame,
        uint256 _player
    ) public view returns (bool) {
        uint8 h;
        uint8 v;
        uint8 rd_i;
        uint8 ld = 0;
        uint8 rd = 0;
        for (uint8 i = 0; i < frameSize; i++) {
            h = 0;
            v = 0;
            rd_i = _abs8(int8(i) - int8(frameSize) + 1);
            for (uint8 j = 0; j < frameSize; j++) {
                // check horizontal
                h += _frame[i][j];
                // check vertical
                v += _frame[j][i];
            }
            if (h == playerScoreWin[_player] || v == playerScoreWin[_player]) {
                return true;
            }
            // check left diagonal
            ld += _frame[i][i];
            // check right diagonal
            rd += _frame[i][rd_i];

            if (
                ld == playerScoreWin[_player] || rd == playerScoreWin[_player]
            ) {
                return true;
            }
        }

        return false;
    }
}
