// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TimeLockedWallet {
    // State variables
    address public owner;
    uint256 public unlockTime;
    uint256 public depositTime;

    // Event to log withdrawals
    event Withdrawal(address indexed user, uint256 amount);

    // Function to set the owner and initial unlock time
    function setOwner(address _owner, uint256 _unlockTime) public {
        require(owner == address(0), "Owner already set.");
        owner = _owner;
        unlockTime = _unlockTime;
    }

    // Function to deposit Ether into the contract
    function deposit() public payable {
        require(msg.value > 0, "Must deposit some Ether.");
        depositTime = block.timestamp; // Record deposit time
    }

    // Function to withdraw Ether after the time lock has passed
    function withdraw(uint256 _amount) public {
        require(msg.sender == owner, "Only the owner can withdraw.");
        require(block.timestamp >= depositTime + unlockTime, "Time lock has not passed.");
        require(address(this).balance >= _amount, "Insufficient balance.");

        // Transfer the requested amount to the owner
        payable(owner).transfer(_amount);

        // Emit an event for the withdrawal
        emit Withdrawal(owner, _amount);
    }

    // Function to check contract balance
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
