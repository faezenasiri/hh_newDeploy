pragma solidity >=0.4.23;

contract Mockcontract {
    bool has;
    bytes32 val;

    function peek() public view returns (bytes32, bool) {
        return (val, has);
    }

    function void() public {
        // unset the value
        has = false;
    }
}
