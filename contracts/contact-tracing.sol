pragma solidity <0.7;

import "./access/roles/maintainer.sol";
import "./access/roles/whitelist/whitelisted.sol";

contract ContactTracing is Maintainer, Whitelisted {
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
	mapping(address => Token) _tokens;

	modifier onlyValidToken(bytes memory t) {
		require(_tokens[msg.sender].status == TokenStatus.Active, "token: token inactive");
		require(_tokens[msg.sender].hash == keccak256(t), "token: invalid token");
		_;
	}

	modifier onlyIssuer(address a) {
		require(_tokens[a].issuer == msg.sender, "token: caller is not the issuer for this token");
		_;
	}

	function submitToken(bytes32 h, address a) onlyWhitelisted external {
		require(!_tokens[a].exist, "token: a token for the address already exist");

		_tokens[a] = Token(h, TokenStatus.Inactive, msg.sender, true);
	}

	function activateToken(address a) onlyIssuer(a) external {
		require(_tokens[a].status == TokenStatus.Inactive, "token: token does not exist or is inactive");

		_tokens[a].status = TokenStatus.Active;
	}

	function submitCuckooFilter(bytes calldata t, uint16[4][] calldata filter) onlyValidToken(t) external {
		require(_insertFilter(msg.sender, filter), "filter: already submitted!");

		_tokens[msg.sender].status = TokenStatus.Consumed;
	}

	function filter(address a) external view returns(uint16[4][] memory) {
		require(_filters[a].exist, "Filter not available for given address");

		return _filters[a].filter;
	}

	function _insertFilter(address a, uint16[4][] memory f) internal returns(bool) { 
		if(_filters[a].exist) return false;

		_filters[a] = CuckooFilter(f, true);
		emit NewInfect(now);
		
		return true;			
	}
}
