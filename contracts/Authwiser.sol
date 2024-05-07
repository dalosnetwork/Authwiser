// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract Authwiser {

    // Mapping to keep track of which wallets have authorized which other wallets
    mapping(address => address[]) private authorizations;

    // Mapping to keep track of the index of each authorized wallet in the `authorizations` array for quick deletion
    mapping(address => mapping(address => uint)) private authIndex;

    // Mapping to keep track of who authorized a specific wallet
    mapping(address => address[]) private authorizedBy;
    
    // Mapping to keep track of the index of each authorizing wallet in the `authorizedBy` array for quick deletion
    mapping(address => mapping(address => uint)) private authByIndex;

    event Authorized(address indexed _from, address indexed _to);
    event Deauthorized(address indexed _from, address indexed _to);
    event AuthCall(address indexed _from, address _targetContract, bytes data);

    function authorize(address _authorized) external returns (bool) {
        require(authIndex[msg.sender][_authorized] == 0, "Address already authorized");

        // Auth
        assembly {
            auth(_authorized)
        }

        // Add to the authorizations list
        authorizations[msg.sender].push(_authorized);
        authIndex[msg.sender][_authorized] = authorizations[msg.sender].length - 1;

        // Add to the authorizedBy list
        authorizedBy[_authorized].push(msg.sender);
        authByIndex[_authorized][msg.sender] = authorizedBy[_authorized].length - 1;

        emit Authorized(msg.sender, _authorized);
        return true;
    }

    function deauthorize(address _authorized) external returns (bool) {
        require(authIndex[msg.sender][_authorized] != 0, "Address not authorized");

        // Deauth
        assembly {
            deauth(_authorized)
        }

        // Remove from the authorizations list
        uint index = authIndex[msg.sender][_authorized];
        address lastAuthorized = authorizations[msg.sender][authorizations[msg.sender].length - 1];
        authorizations[msg.sender][index] = lastAuthorized;
        authIndex[msg.sender][lastAuthorized] = index;
        authorizations[msg.sender].pop();
        delete authIndex[msg.sender][_authorized];

        // Remove from the authorizedBy list
        uint byIndex = authByIndex[_authorized][msg.sender];
        address lastAuthorizer = authorizedBy[_authorized][authorizedBy[_authorized].length - 1];
        authorizedBy[_authorized][byIndex] = lastAuthorizer;
        authByIndex[_authorized][lastAuthorizer] = byIndex;
        authorizedBy[_authorized].pop();
        delete authByIndex[_authorized][msg.sender];

        emit Deauthorized(msg.sender, _authorized);
        return true;
    }

    function authorizedCall(address targetContract, bytes memory data) public returns (bool) {
        assembly {
            authcall(gas(), targetContract, 0, add(data, 0x20), mload(data), 0, 0)
        }

        emit AuthCall(msg.sender, targetContract, data);
        return true;
    }

    // View all authorized wallets by a specific wallet
    function getAuthorizedAddresses(address _wallet) external view returns (address[] memory) {
        return authorizations[_wallet];
    }

    // View all wallets that have authorized a specific wallet
    function getAuthorizers(address _wallet) external view returns (address[] memory) {
        return authorizedBy[_wallet];
    }
}
