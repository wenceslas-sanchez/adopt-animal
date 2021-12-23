pragma solidity ^0.8.0;

library  AdoptionUtils {
    uint constant maxLength = 20;

    // From https://github.com/provable-things/ethereum-api/blob/master/oraclizeAPI_0.5.sol#L1045
    function uintToString(uint _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = bytes1(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
}
