// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
require("@nomicfoundation/hardhat-toolbox");

const { time } = require("console");
const fs = require("fs");

async function main() {
  const DssDeploy = await ethers.getContractFactory("DssDeploy");
  const dssDeploy = await DssDeploy.deploy();
  await dssDeploy.deployed();

  let config = `
  export const dssDeployaddress = "${dssDeploy.address}"
  `;

  let data = JSON.stringify(config);
  fs.writeFileSync("config.js", JSON.parse(data));
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
