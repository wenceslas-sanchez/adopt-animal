pragma solidity ^0.8.11;

import {Game} from "./Game.sol";

contract NoughtsCrosses is Game {
    // 0 if not played yet, 1 for first player, 4 for second player
    uint8 constant frameSize = 3;
    uint8[2] playerNumber = [uint8(1), uint8(4)];
    uint8[2] playerScoreWin = [uint8(3), uint8(12)];
    struct NCGameInstance {
        GameInstance game;
        uint8[frameSize][frameSize] frame;
    }
    mapping(address => NCGameInstance) games;

    modifier isAlreadyPlaying() {
        bool _r = _isAlreadyPlaying();
        require(
            !_r,
            "You already have a game instance. Please finish it or kill it."
        );
        _;
    }

    modifier isNotAlreadyPlaying() {
        bool _r = _isAlreadyPlaying();
        require(
            _r,
            "You are not playing to this game. Please Start game instance."
        );
        _;
    }

    function _isAlreadyPlayingCheck() public view virtual {
        NCGameInstance memory NULL;
        NULL = games[msg.sender];
    }

    function _isAlreadyPlaying() internal returns (bool _r) {
        (_r, ) = address(msg.sender).call(
            abi.encodePacked(this._isAlreadyPlayingCheck.selector)
        );
        return _r;
    }

    function killGameInstance() public virtual isNotAlreadyPlaying {
        delete games[msg.sender];
    }

    function instanceGame(address _playerTwo) public isAlreadyPlaying {
        uint8[frameSize][frameSize] memory frame;
        games[msg.sender] = NCGameInstance(
            GameInstance(msg.sender, _playerTwo, 0),
            frame
        );
    }

    // Given (x, y), set value to frame
    function action(
        uint8[2] memory _coord,
        uint8[frameSize][frameSize] memory _frame,
        uint256 _player
    ) public returns (uint8[frameSize][frameSize] memory) {
        _frame[_coord[0]][_coord[1]] = playerNumber[_player];

        return _frame;
    }

    function _abs8(int8 x) internal pure returns (uint8 y) {
        y = (x < 0 ? uint8(-x) : uint8(x));
        return y;
    }

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
