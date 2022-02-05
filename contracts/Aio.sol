//SPDX-License-Identifier: Unlicense
pragma solidity 0.6.12;

import "hardhat/console.sol";

import "@aave/protocol-v2/contracts/protocol/lendingpool/LendingPool.sol";
import "@aave/protocol-v2/contracts/protocol/configuration/LendingPoolAddressesProvider.sol";

contract Aio {
    LendingPoolAddressesProvider provider;
    uint256 public amount;
    address public asset;

    constructor(
        uint8 _amount,
        address _asset,
        address _provider
    ) public {
        amount = _amount;
        _asset = asset;
        provider = LendingPoolAddressesProvider(_provider);
    }

    function deposit() external {
        LendingPool lp = LendingPool(provider.getLendingPool());
        lp.deposit(asset, amount, msg.sender, 0);
    }
}
// contract Greeter {
//     string private greeting;

//     // string private number;
//     constructor(string memory _greeting, uint8 _number) {
//         console.log("Deploying a Greeter with greeting:", _greeting, _number);
//         greeting = _greeting;
//         // number
//     }

//     function greet() public view returns (string memory) {
//         return greeting;
//     }

//     function setGreeting(string memory _greeting) public {
//         console.log("Changing greeting from '%s' to '%s'", greeting, _greeting);ct
//         greeting = _greeting;
//     }
// }
