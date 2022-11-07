const config = require("../config.js");

require("@nomicfoundation/hardhat-toolbox");

const fs = require("fs");

async function main() {
  const DssDeploy = await ethers.getContractFactory("DssDeploy");
  const dssDeploy = await DssDeploy.deploy();
  await dssDeploy.deployed();

  let config = `
  module.exports.dssDeployaddress = "${dssDeploy.address}"
  `;

  let data = JSON.stringify(config);
  fs.appendFileSync("config.js", JSON.parse(data));
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
