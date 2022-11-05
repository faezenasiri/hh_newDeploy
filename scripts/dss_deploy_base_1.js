// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
require("@nomicfoundation/hardhat-toolbox");

async function main() {
  const DssDeployBaseA = await ethers.getContractFactory("DssDeployBaseA");
  const dssDeployBaseA = await DssDeployBaseA.deploy();
  await dssDeployBaseA.deployed();
  await dssDeployBaseA.setUp("0xb12BfaDaA2Bb030e97362F4bA4C525e3B63C1781");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
