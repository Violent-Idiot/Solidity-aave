const { expect } = require("chai");
const { ethers } = require("hardhat");
const hre = require("hardhat");

describe("Aio Contract", function () {
  let Aio;
  let aioToken;
  before(async function () {
    Aio = await ethers.getContractFactory("Aave");
    aioToken = await Aio.deploy();
    await aioToken.deployed();
  });
  describe("Deployment", function () {
    it("Check deposit", async function () {
      // const [owner] = await ethers.getSigners();
      // console.log(owner.address);
      // console.log(ethers.utils.parseEther("1"));
      const token = "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE";
      const acc = "0x15BB5127Bd75025AaCe941bC7296fCEEF46980b1";
      await hre.network.provider.request({
        method: "hardhat_impersonateAccount",
        params: ["0x15BB5127Bd75025AaCe941bC7296fCEEF46980b1"],
      });
      // console.log(addr);
      const owner = await ethers.getSigner(
        "0x15BB5127Bd75025AaCe941bC7296fCEEF46980b1"
      );
      console.log(owner.address);
      await aioToken.deposit(token, {
        from: owner.address,
        // from: acc,
        // value: ethers.utils.parseEther("1"),
        value: ethers.utils.parseUnits("1", 0),
      });
    }).timeout(500000);

    it("Check Withdraw", async function () {
      const [owner] = await ethers.getSigners();
      // console.log(owner.address);
      // console.log(ethers.utils.parseEther("1"));
      await aioToken.withdraw({
        from: owner.address,
        value: ethers.utils.parseEther("1"),
      });
    }).timeout(500000);
    it("Check Borrow", async function () {
      const [owner] = await ethers.getSigners();
      // console.log(owner.address);
      await aioToken.deposit({
        from: owner.address,
        value: ethers.utils.parseEther("1"),
      });
      await aioToken.borrow({
        from: owner.address,
        value: ethers.utils.parseEther("0.5"),
      });
    }).timeout(500000);
    it("Check Payback", async function () {
      const [owner] = await ethers.getSigners();
      // console.log(owner.address);
      await aioToken.payback({
        from: owner.address,
        value: ethers.utils.parseEther("0.5"),
      });
    }).timeout(500000);
  });
});
