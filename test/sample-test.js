const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Aio", function () {
  it("Should return the new greeting once it's changed", async function () {
    const Aio = await ethers.getContractFactory("Aio");
    const aio = await Aio.deploy(
      100000000000,
      0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48
    );
    await aio.deployed();

    // expect(await aio.greet()).to.equal("Hello, world!");

    // const setGreetingTx = await aio.setGreeting("Hola, mundo!");

    // wait until the transaction is mined
    // await setGreetingTx.wait();

    // expect(await aio.greet()).to.equal("Hola, mundo!");
  });
});
