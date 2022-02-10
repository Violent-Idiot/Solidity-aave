// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

const { network } = require("hardhat");
async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const Aio = await hre.ethers.getContractFactory("Aave");
  const AioDeploy = await Aio.deploy();
  // "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48"

  await AioDeploy.deployed();
  // await network.provider.request({
  //   method: "hardhat_impersonateAccount",
  //   params: ["0x15BB5127Bd75025AaCe941bC7296fCEEF46980b1"],
  // });

  console.log("Greeter deployed to:", AioDeploy.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
