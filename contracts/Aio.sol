//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

interface LendingPoolAddressesProvider {
    function getLendingPool() external returns (address);
}

interface LendingPool {
    function deposit(
        address asset,
        uint256 amount,
        address onBehalfOf,
        uint16 referralCode
    ) external;
}

contract Aio {
    address public asset;
    uint256 public amount;
    LendingPoolAddressesProvider provider =
        LendingPoolAddressesProvider(
            0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9
        );
    LendingPool lp = LendingPool(0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9);

    constructor(
        uint256 _amount,
        address _asset // address _provider
    ) {
        amount = _amount;
        asset = _asset;
        // provider = LendingPoolAddressesProvider(_provider);
    }

    function deposit() external {
        lp = LendingPool(provider.getLendingPool());
        lp.deposit(asset, amount, msg.sender, 0);
    }
}
