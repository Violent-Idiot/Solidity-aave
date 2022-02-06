const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Aio Contract", function () {
  let Aio;
  let aioToken;
  before(async function () {
    console.log("here");
    Aio = await ethers.getContractFactory("Aio");
    console.log("here2");
    [depositer] = await ethers.getSigners();
    console.log("here3");
    aioToken = await Aio.deploy(
      // Math.pow(10, 18),
      "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48"
    );
    console.log("here4");
  });
  describe("Deployment", () => {
    it("Check deposit", async function () {
      await aioToken.depositETH({
        value: ethers.utils.parseEther("1"),
      });
      const deposit = await aioToken.deposit();
      expect(deposit).to.equal(999);
    });
  });
});
