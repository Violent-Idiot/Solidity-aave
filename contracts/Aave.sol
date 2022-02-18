//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./interface.sol";

contract Aave {
    address weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; //MAINNET
    address aWeth = 0x030bA81f1c18d280636F32af80b9AAd02Cf0854e;
    address adai = 0x028171bCA77440897B824Ca71D1c56caC55b68A3;
    // address weth = 0xd0A1E359811322d97991E03f863a0C30C2cF029C; //KOVAN
    address eth = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    LendingPoolAddressesProvider provider =
        LendingPoolAddressesProvider(
            0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5 //MAINNET
            // 0x88757f2f99175387aB4C6a4b3067c77A695b0349 //KOVAN
        );
    // AaveEth ethHandler = AaveEth(0xcc9a0B7c43DC2a5F023Bb9b738E45B0Ef6B06E04);
    IProtocolDataProvider userData =
        IProtocolDataProvider(0x057835Ad21a177dbdd3090bB1CAE03EaCF78Fc6d);
    LendingPoolConfig config =
        LendingPoolConfig(0x311Bb771e4F8952E6Da169b425E7e92d6Ac45756);

    IAave aave = IAave(provider.getLendingPool());

    function isEth(address addr) internal view returns (bool) {
        return (eth == addr) ? true : false;
    }

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
        Itoken token = Itoken(tokenaddr);
        require(token.balanceOf(msg.sender) >= amt, "Insufficent funds");
        console.log(token.balanceOf(msg.sender));
        console.log(msg.sender);
        token.transferFrom(msg.sender, address(this), amt);
        token.approve(address(aave), amt);
        aave.deposit(tokenaddr, amt, address(this), 0);
        aave.setUserUseReserveAsCollateral(tokenaddr, true);
        uint256 bal;
        bool col;
        (bal, , , , , , , , col) = userData.getUserReserveData(
            tokenaddr,
            address(this)
        );
        console.log(bal, col);
        Itoken adaiToken = Itoken(adai);
        console.log("adai token", adaiToken.balanceOf(address(this)));
        console.log("after deposit", token.balanceOf(address(this)));
    }

    function deposit(address tokenaddr, uint256 amt) external payable {
        console.log(tokenaddr);
        bool _isEth = (tokenaddr == eth) ? true : false;
        tokenaddr = (_isEth) ? weth : tokenaddr;
        amt = (_isEth) ? msg.value : amt;
        Itoken token = Itoken(tokenaddr);
        console.log("ETH bal of sender", msg.sender.balance);
        console.log("ETH bal of contact", address(this).balance);
        console.log("Before deposit to weth", token.balanceOf(address(this)));
        if (_isEth) {
            _ethToWeth(token, amt, address(aave));
        } else {
            token.approve(address(this), amt);
            token.transfer(address(this), amt);
            console.log(token.balanceOf(address(this)));
            token.approve(address(aave), amt);
        }
        console.log("After deposit to weth", token.balanceOf(address(this)));
        aave.deposit(tokenaddr, amt, address(this), 0);
        aave.setUserUseReserveAsCollateral(tokenaddr, true);
        console.log("After deposit to aave", token.balanceOf(address(this)));
        console.log("ETH bal", msg.sender.balance / (10**18));
    }

    function ERCwithdraw(address tokenaddr, uint256 amt) external payable {
        console.log(msg.sender);
        Itoken token = Itoken(tokenaddr);
        console.log("Before Withdraw", token.balanceOf(address(this)));
        aave.withdraw(tokenaddr, amt, address(this));
        console.log("After Withdraw", token.balanceOf(address(this)));
        token.transferFrom(address(this), msg.sender, amt);
    }

    // function ERCborrow(address tokenaddr, uint256 amt) external payable {
    //     Itoken token = Itoken(tokenaddr);
    //     Itoken adaiToken = Itoken(adai);
    //     IAave aave = IAave(provider.getLendingPool());
    //     console.log("adai bal borrow", adaiToken.balanceOf(address(this)));
    //     console.log("amt", amt);

    //     console.log("Borrow", token.balanceOf(address(this)));
    //     aave.borrow(tokenaddr, amt, 1, 0, address(this));
    //     token.transferFrom(address(this), msg.sender, amt);
    // }

    function withdraw() external payable {
        address tokenaddr = weth;
        uint256 amt = msg.value;
        Itoken token = Itoken(tokenaddr);
        console.log("Before Withdraw", token.balanceOf(address(this)));
        aave.withdraw(tokenaddr, amt, address(this));
        console.log("After Withdraw", token.balanceOf(address(this)));
        _wethToEth(token, amt, address(token));
        address payable owner = payable(msg.sender);
        owner.transfer(address(this).balance);
        console.log("After Withdraw of weth", token.balanceOf(address(this)));
        console.log("ETH bal of sender", msg.sender.balance);
        console.log("ETH bal of contact", address(this).balance);
    }

    function borrow(address addr, uint256 amt) external payable {
        Itoken token = Itoken(addr);
        Itoken adaiToken = Itoken(adai);
        console.log("Borrow Collateral", adaiToken.balanceOf(address(this)));
        console.log(amt, addr);
        console.log("Borrow", token.balanceOf(address(this)));
        aave.borrow(addr, amt, 1, 0, address(this));
        console.log("Here2");
        // _wethToEth(token, amt, address(token));
        // address payable owner = payable(msg.sender);
        // owner.transfer(address(this).balance);
        // token.approve(address(token), amt);
        // token.withdraw(amt);
        // Itoken daiToken = Itoken(addr);
        token.transferFrom(address(this), msg.sender, amt);
        // console.log("ETH bal", msg.sender.balance);
        // console.log("ETH bal of sender", msg.sender.balance);
        // console.log("ETH bal of contact", address(this).balance);
    }

    function payback(address tokenaddr, uint256 amt) external payable {
        bool _isEth = isEth(tokenaddr);
        tokenaddr = _isEth ? weth : tokenaddr;
        Itoken token = Itoken(tokenaddr);
        if (!_isEth) {
            token.transferFrom(msg.sender, address(this), amt);
            token.approve(address(aave), amt);
        } else {
            amt = msg.value;
            _ethToWeth(token, amt, address(aave));
        }
        // token.transferFrom(msg.sender, address(this), amt);
        // token.approve(address(aave), amt);
        // _ethToWeth(token, amt, address(aave));

        console.log("before Payback", token.balanceOf(address(this)));

        aave.repay(tokenaddr, amt, 1, address(this));
        console.log("After Payback", token.balanceOf(address(this)));
    }

    fallback() external payable {}
}
