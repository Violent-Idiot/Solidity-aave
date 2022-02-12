//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

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

    function transferFrom(
        address,
        address,
        uint256
    ) external;

    function deposit() external payable;

    function withdraw(uint256) external;

    function balanceOf(address) external view returns (uint256);

    function decimals() external view returns (uint256);
}

interface LendingPoolAddressesProvider {
    function getLendingPool() external returns (address);
}

contract Aave {
    // address constant weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; //MAINNET
    using SafeERC20 for IERC20;

    address weth = 0xd0A1E359811322d97991E03f863a0C30C2cF029C; //KOVAN
    address eth = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    LendingPoolAddressesProvider provider =
        LendingPoolAddressesProvider(
            // 0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5 //MAINNET
            0x88757f2f99175387aB4C6a4b3067c77A695b0349 //KOVAN
        );

    function _ethToWeth(
        Itoken token,
        uint256 amt,
        address addr
    ) internal {
        token.deposit{value: amt}();
        token.approve(addr, amt);
    }

    function _wethToEth(
        Itoken token,
        uint256 amt,
        address addr
    ) internal {
        token.approve(addr, amt);
        token.withdraw(amt);
    }

    function ERCdeposit(address tokenaddr, uint256 amt) external payable {
        console.log(address(this));
        console.log(msg.sender);
        IAave aave = IAave(provider.getLendingPool());
        Itoken token = Itoken(tokenaddr);
        require(token.balanceOf(msg.sender) >= amt, "Insufficent funds");
        // console.log(token.balanceOf(msg.sender));
        // console.log(msg.sender);
        // // token.approve(address(this), amt);
        // console.log("Allowance", token.allowance(msg.sender, address(this)));
        token.transferFrom(msg.sender, address(this), amt);
        // token.transfer(address(this), amt);
        console.log(token.balanceOf(address(this)));
        token.approve(address(aave), amt);
        console.log("here1");
        aave.deposit(tokenaddr, amt, address(this), 0);
        console.log("here2");
    }

    function deposit(address tokenaddr, uint256 amt) external payable {
        // address tokenaddr = weth;
        console.log(tokenaddr);
        bool isEth = (tokenaddr == eth) ? true : false;
        tokenaddr = (isEth) ? weth : tokenaddr;
        amt = (isEth) ? msg.value : amt;
        // address token;
        // uint256 amt = msg.value;
        // if (isEth) {
        Itoken token = Itoken(tokenaddr);
        // } else {
        //     token = IERC20(tokenaddr);
        // }
        IAave aave = IAave(provider.getLendingPool());
        console.log("ETH bal of sender", msg.sender.balance);
        console.log("ETH bal of contact", address(this).balance);
        console.log("Before deposit to weth", token.balanceOf(address(this)));
        if (isEth) {
            _ethToWeth(token, amt, address(aave));
        } else {
            token.approve(address(this), amt);
            // console.log(token.allowance(msg.sender, address(this)));
            token.transfer(address(this), amt);
            console.log(token.balanceOf(address(this)));
            token.approve(address(aave), amt);
        }
        console.log("After deposit to weth", token.balanceOf(address(this)));
        aave.deposit(tokenaddr, amt, address(this), 0);
        // aave.deposit(tokenaddr, amt, msg.sender, 0);
        console.log("After deposit to aave", token.balanceOf(address(this)));
        console.log("ETH bal", msg.sender.balance);
    }

    function withdraw() external payable {
        address tokenaddr = weth;
        uint256 amt = msg.value;
        Itoken token = Itoken(tokenaddr);
        IAave aave = IAave(provider.getLendingPool());
        console.log("Before Withdraw", token.balanceOf(address(this)));
        aave.withdraw(tokenaddr, amt, address(this));
        console.log("After Withdraw", token.balanceOf(address(this)));
        _wethToEth(token, amt, address(token));
        address payable owner = payable(msg.sender);
        owner.transfer(address(this).balance);
        console.log("After Withdraw of weth", token.balanceOf(address(this)));
        console.log("ETH bal of sender", msg.sender.balance);
        console.log("ETH bal of contact", address(this).balance);
        // return token.balanceOf(address(this));
    }

    function borrow() external payable {
        address tokenaddr = weth;
        uint256 amt = msg.value;
        Itoken token = Itoken(tokenaddr);
        IAave aave = IAave(provider.getLendingPool());
        aave.borrow(tokenaddr, amt, 1, 0, address(this));
        console.log("Borrow", token.balanceOf(address(this)));
        _wethToEth(token, amt, address(token));
        address payable owner = payable(msg.sender);
        owner.transfer(address(this).balance);
        console.log("ETH bal", msg.sender.balance);
        console.log("ETH bal of sender", msg.sender.balance);
        console.log("ETH bal of contact", address(this).balance);
    }

    function payback() external payable {
        address tokenaddr = weth;
        uint256 amt = msg.value;
        Itoken token = Itoken(tokenaddr);
        IAave aave = IAave(provider.getLendingPool());

        _ethToWeth(token, amt, address(aave));

        console.log("Before Payback", token.balanceOf(address(this)));
        aave.repay(tokenaddr, amt, 1, address(this));
        console.log("After Payback", token.balanceOf(address(this)));
    }

    fallback() external payable {}
}
