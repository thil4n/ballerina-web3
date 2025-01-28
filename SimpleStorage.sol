// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage {
    uint256 private storedValue;

    // Function to store a value
    function store(uint256 _value) public {
        storedValue = _value;
    }

    // Function to retrieve the stored value
    function retrieve() public view returns (uint256) {
        return storedValue;
    }
}