pragma solidity <0.7.0;

import "./Context.sol";

contract MetaContext is Context {
    function sender() internal view override returns(address payable) {
        if(msg.sender != address(this)) {
            return msg.sender;
        }

        return _sender();
    }

    function data() internal view override returns(bytes memory) {
        if(msg.sender != address(this)) {
            return msg.data;
        }

        return _data();
    }

    function _sender() internal pure returns(address payable result) {
        bytes memory d = msg.data;
        uint256 i = msg.data.length;

        assembly {
            result := and(mload(add(d, i)), 0xffffffffffffffffffffffffffffffffffffffff)
        }

        return result;
    }

    function _data() internal pure returns(bytes memory) {
        uint256 length = msg.data.length - 20;
        bytes memory d = new bytes(length);

        for(uint256 i = 0; i < length; i++) {
            d[i] = msg.data[i];
        }

        return d;
    }
}