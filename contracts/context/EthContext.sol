pragma solidity <0.7.0;

import "./Context.sol";

contract EthContext is Context {
    function sender() internal view override returns(address payable) {
        return msg.sender;
    }

    function data() internal view override returns(bytes memory) {
        this;
        return msg.data;
    }
}