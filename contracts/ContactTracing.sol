pragma solidity <0.7;

import "./access/roles/Maintainer.sol";
import "./access/roles/whitelist/Whitelisted.sol";
import "./metacall/MetaCallable.sol";
import "./context/MetaContext.sol";

contract ContactTracing is MetaContext, MetaCallable, Maintainer, Whitelisted {
	struct CuckooFilter {
		uint16[4][] filter;
		bool exist;
	}

	enum TokenStatus { Inactive, Active, Consumed }

	struct Token {
		bytes32 hash;
		TokenStatus status;
		address issuer;
		bool exist;
	}

	event NewInfect(uint256 timestamp);

	mapping(address => CuckooFilter) _filters;
	mapping(address => Token) public _tokens;

	modifier onlyValidToken(bytes memory t) {
		require(_tokens[sender()].status == TokenStatus.Active, "Token: token inactive");
		require(_tokens[sender()].hash == keccak256(t), "Token: invalid token");
		_;
	}

	modifier onlyIssuer(address a) {
		require(_tokens[a].issuer == sender(), "Token: caller is not the issuer for this token");
		_;
	}
	
	function submitToken(bytes32 h, address a) onlyWhitelisted external {
		require(!_tokens[a].exist, "Token: a token for the address already exist");

		_tokens[a] = Token(h, TokenStatus.Inactive, sender(), true);
	}

	function activateToken(address a) onlyIssuer(a) external {
		require(_tokens[a].status == TokenStatus.Inactive, "Token: token does not exist or is inactive");

		_tokens[a].status = TokenStatus.Active;
	}

	function submitCuckooFilter(bytes calldata t, uint16[4][] calldata filter) onlyValidToken(t) external {
		require(_insertFilter(sender(), filter), "Filter: already submitted!");

		_tokens[sender()].status = TokenStatus.Consumed;
	}

	function filter(address a) external view returns(uint16[4][] memory) {
		require(_filters[a].exist, "Filter: not available for given address");

		return _filters[a].filter;
	}
	
	function _insertFilter(address a, uint16[4][] memory f) internal returns(bool) { 
		if(_filters[a].exist) return false;

		_filters[a] = CuckooFilter(f, true);
		emit NewInfect(now);
		
		return true;			
	}
}
