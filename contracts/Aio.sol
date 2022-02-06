//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

interface LendingPoolAddressesProvider {
    function getLendingPool() external returns (address);
}

interface WethGateway {
    function depositETH(
        address lendingPool,
        address onBehalfOf,
        uint16 referralCode
    ) external;
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
    address public asset; //0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2;
    uint256 public amount;
    address public depositer;
    mapping(address => uint256) bal;
    LendingPoolAddressesProvider provider =
        LendingPoolAddressesProvider(
            0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9
        );
    LendingPool lp = LendingPool(0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9);
    WethGateway wg = WethGateway(0xcc9a0B7c43DC2a5F023Bb9b738E45B0Ef6B06E04);

    constructor(
        // uint256 _amount;
        address _asset // address _provider
    ) payable {
        // amount = _amount;
        asset = _asset;
        // provider = LendingPoolAddressesProvider(_provider);
    }

    function deposit() external payable {
        lp = LendingPool(provider.getLendingPool());
        wg.depositETH(address(lp), msg.sender, 0);
        lp.deposit(asset, amount, msg.sender, 0);
    }
}
