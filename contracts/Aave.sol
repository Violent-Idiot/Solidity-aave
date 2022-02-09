//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

interface IAave {
    function deposit(
        address asset,
        uint256 amount,
        address onBehalfOf,
        uint16 referralCode
    ) external;

    function withdraw(
        address asset,
        uint256 amount,
        address to
    ) external;

    function borrow(
        address asset,
        uint256 amount,
        uint256 interestRateMode,
        uint16 referralCode,
        address onBehalfOf
    ) external;

    function repay(
        address asset,
        uint256 amount,
        uint256 rateMode,
        address onBehalfOf
    ) external;
}

interface Itoken {
    function approve(address, uint256) external;

    function transfer(address, uint256) external;

    function deposit() external payable;

    function withdraw(uint256) external;

    function balanceOf(address) external view returns (uint256);
}

interface LendingPoolAddressesProvider {
    function getLendingPool() external returns (address);
}

contract Aave {
    // address constant weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; //MAINNET
    address weth = 0xd0A1E359811322d97991E03f863a0C30C2cF029C; //KOVAN

    function deposit() external payable {
        address tokenaddr = weth;
        uint256 amt = msg.value;
        Itoken token = Itoken(tokenaddr);
        LendingPoolAddressesProvider provider = LendingPoolAddressesProvider(
            // 0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5 //MAINNET
            0x88757f2f99175387aB4C6a4b3067c77A695b0349 //KOVAN
        );
        IAave aave = IAave(provider.getLendingPool());
        // console.log(msg.sender, address(this));
        console.log("Before deposit to weth", token.balanceOf(address(this)));
        token.deposit{value: amt}();
        token.approve(address(aave), amt);
        console.log("After deposit to weth", token.balanceOf(address(this)));
        aave.deposit(tokenaddr, amt, address(this), 0);
        console.log("After deposit to aave", token.balanceOf(address(this)));
    }

    function withdraw() external payable {
        address tokenaddr = weth;
        uint256 amt = msg.value;
        Itoken token = Itoken(tokenaddr);
        LendingPoolAddressesProvider provider = LendingPoolAddressesProvider(
            // 0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5 //MAINNET
            0x88757f2f99175387aB4C6a4b3067c77A695b0349 //KOVAN
        );
        IAave aave = IAave(provider.getLendingPool());
        console.log("Before Withdraw", token.balanceOf(address(this)));
        aave.withdraw(tokenaddr, amt, address(this));
        console.log("After Withdraw", token.balanceOf(address(this)));
        token.approve(address(token), amt);
        token.withdraw(amt);
        console.log("After Withdraw of weth", token.balanceOf(address(this)));

        // return token.balanceOf(address(this));
    }

    function borrow() external payable {
        address tokenaddr = weth;
        uint256 amt = msg.value;
        Itoken token = Itoken(tokenaddr);
        LendingPoolAddressesProvider provider = LendingPoolAddressesProvider(
            // 0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5 //MAINNET
            0x88757f2f99175387aB4C6a4b3067c77A695b0349 //KOVAN
        );
        IAave aave = IAave(provider.getLendingPool());
        aave.borrow(tokenaddr, amt, 1, 0, address(this));
        console.log("Borrow", token.balanceOf(address(this)));
        token.approve(address(token), amt);
        token.withdraw(amt);
    }

    function payback() external payable {
        address tokenaddr = weth;
        uint256 amt = msg.value;
        Itoken token = Itoken(tokenaddr);
        LendingPoolAddressesProvider provider = LendingPoolAddressesProvider(
            // 0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5 //MAINNET
            0x88757f2f99175387aB4C6a4b3067c77A695b0349 //KOVAN
        );
        IAave aave = IAave(provider.getLendingPool());

        token.deposit{value: amt}();
        token.approve(address(aave), amt);

        console.log("Before Payback", token.balanceOf(address(this)));
        aave.repay(tokenaddr, amt, 1, address(this));
        console.log("After Payback", token.balanceOf(address(this)));
    }

    fallback() external payable {}
}
