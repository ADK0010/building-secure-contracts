// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.5.0;

contract Owned {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}

contract Coin is Owned {
    mapping(address => uint256) balances;
    uint256 decimals = 1 ** 18;

    event Mint(address indexed destination, uint256 amount);

    /// @notice Mint tokens
    /// @param addr The address holding the new token
    /// @param value The amount of token to be minted
    /// @dev This function performed no check on the caller. Must stay internal
    function _mint(address addr, uint256 value) internal {
        balances[addr] += value;
        require(balances[addr] >= value);
        emit Mint(addr, value);
    }

    /// @notice Mint tokens. Callable only by the owner
    /// @param addr The address holding the new token
    /// @param value The amount of token to be minted
    function mint(address addr, uint256 value) public onlyOwner {
        _mint(addr, value);
    }

    /// @notice Mint tokens. Used by the owner to mint directly tokens to himself. Callable only by the owner
    /// @param value The amount of token to be minted
    function mint(uint256 value) public {
        _mint(msg.sender, value);
    }

    /// @notice Return the user's balance
    /// @param dst User address
    function balanceOf(address dst) public returns (uint256) {
        return balances[msg.sender];
    }
}
