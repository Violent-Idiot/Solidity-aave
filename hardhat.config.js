const { task } = require("hardhat/config");

require("@nomiclabs/hardhat-waffle");
require("dotenv").config();
// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});
task("demo", "give details of acc", async (taskArgs, hre) => {
  await hre.network.provider.request({
    method: "hardhat_impersonateAccount",
    params: ["0x15BB5127Bd75025AaCe941bC7296fCEEF46980b1"],
  });
  // console.log(addr);
  // const owner = await ethers.getSigner(
  //   "0x15BB5127Bd75025AaCe941bC7296fCEEF46980b1"
  // );
  ethers
    .getSigner("0x15BB5127Bd75025AaCe941bC7296fCEEF46980b1")
    .then((res) => console.log(res.address));

  // console.log(owner.getBalance());
  // let bal = hre.network.provider.getBalance("ethers.eth");
  // console.log(bal);
});
// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.4",
  networks: {
    hardhat: {
      forking: {
        url: process.env.INFURA,
        accounts: [process.env.SECRET_KEY],
      },
    },
    // kovan: {
    //   url: process.env.INFURA,
    //   accounts: [process.env.SECRET_KEY],
    // },
  },
};
