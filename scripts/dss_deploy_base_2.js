
require("@nomicfoundation/hardhat-toolbox");
const config = require("../config.js");


const fs = require("fs");

async function main() {
  const DssDeployBaseB = await ethers.getContractFactory("DssDeployBaseB");
  const dssDeployBaseB = await DssDeployBaseB.deploy();
  await dssDeployBaseB.deployed();

  await dssDeployBaseB.setUp(config.dssDeployaddress);

  const DssDeployBaseC = await ethers.getContractFactory("DssDeployBaseC");
  const dssDeployBaseC = await DssDeployBaseC.deploy();
  await dssDeployBaseC.deployed();
  await dssDeployBaseC.setUp(config.dssDeployaddress);

  const DssDeployBaseD = await ethers.getContractFactory("DssDeployBaseD");
  const dssDeployBaseD = await DssDeployBaseD.deploy();
  await dssDeployBaseD.deployed();
  await dssDeployBaseD.setUp(config.dssDeployaddress);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
