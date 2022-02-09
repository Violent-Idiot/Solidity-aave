const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Aio Contract", function () {
  let Aio;
  let aioToken;
  before(async function () {
    // console.log("here");
    Aio = await ethers.getContractFactory("Aave");
    // console.log("here2");
    // console.log("here3");
    aioToken = await Aio.deploy();
    await aioToken.deployed();
    // Math.pow(10, 18),
    // "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48"
    // console.log("here4");
  });
  describe("Deployment", function () {
    it("Check deposit", async function () {
      const [owner] = await ethers.getSigners();
      console.log(owner.address);
      // console.log(ethers.utils.parseEther("1"));
      await aioToken.deposit({
        from: owner.address,
        value: ethers.utils.parseEther("1"),
      });
    }).timeout(500000);

    it("Check Withdraw", async function () {
      const [owner] = await ethers.getSigners();
      console.log(owner.address);
      // console.log(ethers.utils.parseEther("1"));
      await aioToken.withdraw({
        from: owner.address,
        value: ethers.utils.parseEther("1"),
      });
    }).timeout(500000);
    it("Check Borrow", async function () {
      const [owner] = await ethers.getSigners();
      console.log(owner.address);
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
      console.log(owner.address);
      await aioToken.payback({
        from: owner.address,
        value: ethers.utils.parseEther("0.5"),
      });
    }).timeout(500000);
  });
});
