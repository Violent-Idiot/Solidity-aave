const { expect } = require("chai");
const { ethers, network } = require("hardhat");
const hre = require("hardhat");
const abi = require("./abi.json");
describe("Aio Contract", function () {
  let Aio;
  let aioToken;
  let contractAddr;
  let account = "0x9a7a9d980ed6239b89232c012e21f4c210f4bef1"; //DAI WHALE
  let eth = "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE";
  // let dai = "0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa"; //KOVAN
  let dai = "0x6b175474e89094c44da98b954eedeac495271d0f"; //MAINNET
  before(async function () {
    Aio = await ethers.getContractFactory("Aave");
    aioToken = await Aio.deploy();
    contractAddr = await aioToken.deployed();
    // console.log(addr.address);
  });
  describe("Deployment", function () {
    it("Check Deposit DAI", async function () {
      const amt = ethers.utils.parseEther("0.000001");

      const provider = ethers.provider;

      const contract = new ethers.Contract(dai, abi.result, provider);
      const [owner] = await ethers.getSigners();
      await network.provider.send("hardhat_setBalance", [
        account,
        ethers.utils.parseEther("10.0").toHexString(),
      ]);
      await hre.network.provider.request({
        method: "hardhat_impersonateAccount",
        params: [account],
      });
      const myAcc = await ethers.getSigner(account);
      // let bal = await provider.getBalance(account);
      // console.log(ethers.utils.formatEther(bal));
      bal = await contract.connect(myAcc).balanceOf(account);
      console.log(ethers.utils.formatEther(bal));
      await contract.connect(myAcc).transfer(owner.address, amt);
      bal = await contract.connect(owner).balanceOf(owner.address);
      console.log(ethers.utils.formatEther(bal));
      await hre.network.provider.request({
        method: "hardhat_stopImpersonatingAccount",
        params: [account],
      });
      await contract.connect(owner).approve(contractAddr.address, amt);
      await aioToken.ERCdeposit(dai, amt);
    }).timeout(500000);
    it("Check withdrawal DAI", async function () {
      const amt = ethers.utils.parseEther("0.000001");
      const provider = ethers.provider;
      const contract = new ethers.Contract(dai, abi.result, provider);
      const [owner] = await ethers.getSigners();
      await aioToken.ERCwithdraw(dai, amt);
      let bal = await contract.connect(owner).balanceOf(owner.address);
      console.log(bal);
    }).timeout(500000);
    it("Check Borrow DAI", async function () {
      const amt = ethers.utils.parseEther("0.000001");

      const provider = ethers.provider;

      const contract = new ethers.Contract(dai, abi.result, provider);
      const [owner] = await ethers.getSigners();
      await network.provider.send("hardhat_setBalance", [
        account,
        ethers.utils.parseEther("10.0").toHexString(),
      ]);
      await hre.network.provider.request({
        method: "hardhat_impersonateAccount",
        params: [account],
      });
      const myAcc = await ethers.getSigner(account);
      // let bal = await provider.getBalance(account);
      // console.log(ethers.utils.formatEther(bal));
      let bal = await contract.connect(myAcc).balanceOf(account);
      console.log(ethers.utils.formatEther(bal));
      await contract.connect(myAcc).transfer(owner.address, amt);
      bal = await contract.connect(owner).balanceOf(owner.address);
      console.log(ethers.utils.formatEther(bal));
      await hre.network.provider.request({
        method: "hardhat_stopImpersonatingAccount",
        params: [account],
      });
      await contract.connect(owner).approve(contractAddr.address, amt);
      await aioToken.ERCdeposit(dai, amt);
      await aioToken.ERCborrow(dai, ethers.utils.parseEther("0.000000000001"));
      bal = await contract.connect(owner).balanceOf(owner.address);
      console.log(bal);
    }).timeout(500000);

    it("Check deposit", async function () {
      const token = "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE";
      const [owner] = await ethers.getSigners();
      await aioToken.deposit(token, ethers.utils.parseEther("1"), {
        from: owner.address,
        value: ethers.utils.parseEther("1"),
      });
    }).timeout(500000);

    it("Check Withdraw", async function () {
      const [owner] = await ethers.getSigners();
      await aioToken.withdraw({
        from: owner.address,
        value: ethers.utils.parseEther("1"),
      });
    }).timeout(500000);

    it("Check Borrow", async function () {
      const [owner] = await ethers.getSigners();

      await aioToken.deposit(eth, ethers.utils.parseEther("1"), {
        from: owner.address,
        value: ethers.utils.parseEther("1"),
      });
      await aioToken.borrow(eth, ethers.utils.parseEther("0.0001"), {
        from: owner.address,
        value: ethers.utils.parseEther("0.0001"),
      });
    }).timeout(500000);

    it("Check Payback", async function () {
      const [owner] = await ethers.getSigners();
      // console.log(owner.address);
      await aioToken.payback({
        from: owner.address,
        value: ethers.utils.parseEther("1"),
      });
    }).timeout(500000);
  });
});
