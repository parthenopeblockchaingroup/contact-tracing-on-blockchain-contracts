pragma solidity <0.7.0;

/* Thanks to Openzeppelin */

library Roles {
	struct Role {
		mapping(address => bool) bearer;
	}

	function add(Role storage role, address account) internal {
		require(!has(role, account), "roles: account already has role");
		role.bearer[account] = true;
	}

	function remove(Role storage role, address account) internal {
		require(has(role, account), "roles: account does not have role");
		role.bearer[account] = false;
	}

	function has(Role storage role, address account) internal view returns(bool) {
		require(account != address(0), "roles: account is zero address");
		return role.bearer[account];
	}
}
