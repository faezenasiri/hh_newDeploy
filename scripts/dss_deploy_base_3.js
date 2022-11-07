const config = require("../config.js");
require("@nomicfoundation/hardhat-toolbox");

const fs = require("fs");

async function main() {
  const DssDeployBaseE = await ethers.getContractFactory("DssDeployBaseE");
  const dssDeployBaseE = await DssDeployBaseE.deploy();
  await dssDeployBaseE.deployed();

  await dssDeployBaseE.setUp(config.dssDeployaddress);

  const DssDeployBaseF = await ethers.getContractFactory("DssDeployBaseF");
  const dssDeployBaseF = await DssDeployBaseF.deploy();
  await dssDeployBaseF.deployed();
  await dssDeployBaseF.setUp(config.dssDeployaddress);
}
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
