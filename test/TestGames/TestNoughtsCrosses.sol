pragma solidity ^0.8.11;

import {Assert} from "truffle/Assert.sol";
import {NoughtsCrosses} from "../../contracts/Games/NoughtsCrosses.sol";

contract TestNoughtsCrosses is NoughtsCrosses {
    function testAbs8() public {
        uint8 result = _abs8(int8(1));
        Assert.equal(result, uint8(1), "Result should be : |1| == 1");

        result = _abs8(int8(-1));
        Assert.equal(result, uint8(1), "Result should be : |-1| == 1");

        result = _abs8(int8(0));
        Assert.equal(result, uint8(0), "Result should be : |0| == 0");
    }

    function playerDoesntExist() public {
        uint8[2] memory coord = [uint8(0), uint8(0)];
        uint8[frameSize][frameSize] memory frame = generateGameFrame();
        frame = _action(coord, frame, 2);
    }

    function coordDoesntExist() public {
        uint8[2] memory coord = [uint8(0), uint8(4)];
        uint8[frameSize][frameSize] memory frame = generateGameFrame();
        frame = _action(coord, frame, 0);
    }

    function testAction() public {
        bool r;
        uint8[2] memory coord = [uint8(0), uint8(0)];
        uint8[frameSize][frameSize] memory frame = generateGameFrame();

        frame = _action(coord, frame, 0);
        uint8 result = frame[0][0];
        Assert.equal(result, uint8(1), "Player 1 set value 1 to [0, 0].");

        coord = [uint8(0), uint8(1)];
        frame = _action(coord, frame, 1);
        result = frame[0][1];
        Assert.equal(result, uint8(4), "Player 2 set value 4 to [0, 1].");

        // Test player 3 can't play
        (r, ) = address(this).call(
            abi.encodePacked(this.playerDoesntExist.selector)
        );
        Assert.isFalse(r, "There are only 2 players (0-indexed).");

        // Test override a value
        coord = [uint8(0), uint8(1)];
        frame = _action(coord, frame, 0);
        result = frame[0][1];
        Assert.equal(result, uint8(1), "Player 1 set value 1 to [0, 1].");

        // Test an impossible pairwise.
        (r, ) = address(this).call(
            abi.encodePacked(this.coordDoesntExist.selector)
        );
        Assert.isFalse(r, "The frame only contains 3x3 box (0-indexed).");
    }

    // Expected usage with value 1 and 4
    function testCheckWinnerExpectedUsage() public {
        uint8[frameSize][frameSize] memory frame = generateGameFrame();
        frame[0] = [uint8(1), uint8(1), uint8(1)];

        // Test horizontal
        bool result = checkWinner(frame, 0);
        Assert.isTrue(result, "Player 1 won.");
        result = checkWinner(frame, 1);
        Assert.isFalse(result, "Player 2 lost.");

        frame[0] = [uint8(4), uint8(4), uint8(4)];
        result = checkWinner(frame, 1);
        Assert.isTrue(result, "Player 2 won.");
        result = checkWinner(frame, 0);
        Assert.isFalse(result, "Player 1 lost.");

        frame[1] = [uint8(4), uint8(4), uint8(4)];
        result = checkWinner(frame, 1);
        Assert.isTrue(result, "Player 2 won.");
        result = checkWinner(frame, 0);
        Assert.isFalse(result, "Player 1 lost.");

        // Test vertical
        frame[2] = [uint8(4), uint8(1), uint8(1)];
        result = checkWinner(frame, 1);
        Assert.isTrue(result, "Player 2 won.");
        result = checkWinner(frame, 0);
        Assert.isFalse(result, "Player 1 lost.");

        frame[2] = [uint8(1), uint8(4), uint8(1)];
        result = checkWinner(frame, 1);
        Assert.isTrue(result, "Player 2 won.");
        result = checkWinner(frame, 0);
        Assert.isFalse(result, "Player 1 lost.");

        // Test right diagonal
        frame[0] = [uint8(4), uint8(4), uint8(1)];
        frame[1] = [uint8(4), uint8(1), uint8(4)];
        frame[2] = [uint8(1), uint8(4), uint8(4)];
        result = checkWinner(frame, 0);
        Assert.isTrue(result, "Player 1 won.");
        result = checkWinner(frame, 1);
        Assert.isFalse(result, "Player 2 lost.");

        // Test left diagonal
        frame[1] = [uint8(4), uint8(4), uint8(4)];
        result = checkWinner(frame, 1);
        Assert.isTrue(result, "Player 2 won.");
        result = checkWinner(frame, 0);
        Assert.isFalse(result, "Player 1 lost.");

        // Both won
        frame[0] = [uint8(4), uint8(4), uint8(1)];
        frame[1] = [uint8(4), uint8(1), uint8(1)];
        frame[2] = [uint8(4), uint8(4), uint8(1)];
        result = checkWinner(frame, 0);
        Assert.isTrue(result, "Player 1 won.");
        result = checkWinner(frame, 1);
        Assert.isTrue(result, "Player 2 won.");
    }
}
