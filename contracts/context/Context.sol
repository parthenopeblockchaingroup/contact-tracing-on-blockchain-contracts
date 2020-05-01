pragma solidity <0.7.0;

abstract contract Context {
    function sender() internal view virtual returns(address payable);
    function data() internal view virtual returns(bytes memory); 
}