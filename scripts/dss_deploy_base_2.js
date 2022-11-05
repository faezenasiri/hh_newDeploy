// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
require("@nomicfoundation/hardhat-toolbox");

const fs = require("fs");

async function main() {
  const DssDeployBaseB = await ethers.getContractFactory("DssDeployBaseB");
  const dssDeployBaseB = await DssDeployBaseB.deploy();
  await dssDeployBaseB.deployed();

  await dssDeployBaseB.setUp("0xb12BfaDaA2Bb030e97362F4bA4C525e3B63C1781");

  const DssDeployBaseC = await ethers.getContractFactory("DssDeployBaseC");
  const dssDeployBaseC = await DssDeployBaseC.deploy();
  await dssDeployBaseC.deployed();
  await dssDeployBaseC.setUp("0xb12BfaDaA2Bb030e97362F4bA4C525e3B63C1781");

  const DssDeployBaseD = await ethers.getContractFactory("DssDeployBaseD");
  const dssDeployBaseD = await DssDeployBaseD.deploy();
  await dssDeployBaseD.deployed();
  await dssDeployBaseD.setUp("0xb12BfaDaA2Bb030e97362F4bA4C525e3B63C1781");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
