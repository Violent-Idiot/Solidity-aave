const { expect } = require("chai");
const { ethers } = require("hardhat");
const hre = require("hardhat");
const abi = require("./abi.json");
describe("Aio Contract", function () {
  let Aio;
  let aioToken;
  let contractAddr;
  before(async function () {
    Aio = await ethers.getContractFactory("Aave");
    aioToken = await Aio.deploy();
    contractAddr = await aioToken.deployed();
    // console.log(addr.address);
  });
  describe("Deployment", function () {
    it("Check Deposit ERC20", async function () {
      // const token = "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE";
      const token = "0x4f96fe3b7a6cf9725f59d353f723c1bdb64ca6aa";
      await hre.network.provider.request({
        method: "hardhat_impersonateAccount",
        params: ["0x15BB5127Bd75025AaCe941bC7296fCEEF46980b1"],
      });
      const provider = new ethers.providers.JsonRpcProvider(process.env.INFURA);
      const daiAddress = "0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa";
      const owner = await ethers.getSigner(
        "0x15BB5127Bd75025AaCe941bC7296fCEEF46980b1"
      );
      const signed = await provider.getSigner(
        "0x15BB5127Bd75025AaCe941bC7296fCEEF46980b1"
      );
      const daiContract = new ethers.Contract(daiAddress, abi.result, signed);
      let bal = await daiContract.balanceOf(
        "0x15BB5127Bd75025AaCe941bC7296fCEEF46980b1"
      );
      console.log(bal, contractAddr.address);
      daiContract
        .transfer(contractAddr.address, ethers.utils.parseUnits("1", 0))
        .then((res) => console.log(res))
        .catch((err) => console.log(err));
      console.log(owner.address, ethers.utils.parseUnits("1", 0));

      await aioToken.connect(owner).ERCdeposit(token, 1, {
        // from: owner.address,
        // value: ethers.utils.parseUnits("1", 17),
      });
    }).timeout(500000);
    it("Check deposit", async function () {
      const [owner] = await ethers.getSigners();
      // console.log(owner.address);
      // console.log(ethers.utils.parseEther("1"));
      // const token = "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE";
      // const acc = "0x15BB5127Bd75025AaCe941bC7296fCEEF46980b1";
      // await hre.network.provider.request({
      //   method: "hardhat_impersonateAccount",
      //   params: ["0x15BB5127Bd75025AaCe941bC7296fCEEF46980b1"],
      // });
      // // console.log(addr);
      // const owner = await ethers.getSigner(
      //   "0x15BB5127Bd75025AaCe941bC7296fCEEF46980b1"
      // );
      // console.log(owner.address, ethers.utils.parseUnits("1", 0));
      await aioToken.deposit({
        from: owner.address,
        // from: acc,
        value: ethers.utils.parseEther("1"),
        // value: ethers.utils.parseUnits("1", 0),
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
