pragma solidity ^0.4.24;

// Import the library 'Roles'
import "./Roles.sol";

// Define a contract 'ConsumerRole' to manage this role - add, remove, check
contract ConsumerRole {
  using Roles for Roles.Role;

  // Define 2 events, one for Adding, and other for Removing
  event ConsumerAdded(address indexed account);
  event ConsumerRemoved(address indexed account);

  // Define a struct 'consumers' by inheriting from 'Roles' library, struct Role
  Roles.Role private consumers;

  // In the constructor make the address that deploys this contract the 1st consumer
  constructor() public {
    _addConsumer(msg.sender);
  }

  // Define a modifier that checks to see if msg.sender has the appropriate role
  modifier onlyConsumer() {
    require(isConsumer(msg.sender), "It hasn't the appropriate Role");
    _;
  }

  // Define a function 'isConsumer' to check this role
  function isConsumer(address account) public view returns (bool) {
    return _checkRoleConsumer(account);
  }

  // Define a function 'addConsumer' that adds this role
  function addConsumer(address account) public onlyConsumer {
    _addConsumer(account);
  }

  // Define a function 'renounceConsumer' to renounce this role
  function renounceConsumer() public {
    address account = msg.sender;
    _removeConsumer(account);
  }
    
  function _checkRoleConsumer(address account) private view returns (bool) {
    // If the value was never set, it will return the default value.
    // mapping in solidity got no length, then use count var
    return (consumers.count > 0 && consumers.has(account));
  }

  // Define an internal function '_addConsumer' to add this role, called by 'addConsumer'
  function _addConsumer(address account) internal {
    if(!_checkRoleConsumer(account)) {
      consumers.add(account);
      emit ConsumerAdded(account);
    }
  }

  // Define an internal function '_removeConsumer' to remove this role, called by 'removeConsumer'
  function _removeConsumer(address account) internal {
    if(_checkRoleConsumer(account)) {
      consumers.remove(account);
      emit ConsumerRemoved(account);
    }
  }
}