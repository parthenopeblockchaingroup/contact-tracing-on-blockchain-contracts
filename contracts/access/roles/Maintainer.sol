pragma solidity <0.7.0;

import "../Roles.sol";

contract Maintainer {
	using Roles for Roles.Role;

	event MaintainerAdded(address indexed account);
	event MaintainerRemoved(address indexed account);

	Roles.Role private _maintainer;

	modifier onlyMaintainer() {
		require(isMaintainer(msg.sender), "maintainer: caller does not have maintainer role");
		_;
	}
	
	constructor() public {
		_maintainer.add(msg.sender);
	}

	function isMaintainer(address account) public view returns(bool) {
		return _maintainer.has(account);
	}

	function addMaintainer(address account) public onlyMaintainer {
		_addMaintainer(account);
	}

	function removeMaintainer(address account) public onlyMaintainer {
		_removeMaintainer(account);
	}

	function renounceMaintainer() public {
		_removeMaintainer(msg.sender);
	}

	function _addMaintainer(address account) internal {
		_maintainer.add(account);
		emit MaintainerAdded(account);
	}

	function _removeMaintainer(address account) internal {
		_maintainer.remove(account);
		emit MaintainerRemoved(account);
	}
}
