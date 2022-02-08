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
      // console.log(ethers.utils.parseUnits("1", "wei"));
      await aioToken.deposit(1, {
        from: owner.address,
        value: ethers.utils.parseUnits("1", "wei"),
      });
    }).timeout(500000);
  });
});
