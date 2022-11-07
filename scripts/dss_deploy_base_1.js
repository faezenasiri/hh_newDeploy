const config = require("../config.js");

require("@nomicfoundation/hardhat-toolbox");

async function main() {
  const DssDeployBaseA = await ethers.getContractFactory("DssDeployBaseA");
  const dssDeployBaseA = await DssDeployBaseA.deploy();
  await dssDeployBaseA.deployed();
  await dssDeployBaseA.setUp(config.dssDeployaddress);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
