require("@nomicfoundation/hardhat-toolbox");
const col = require("../../onboard_collateral.js");
const fs = require('fs');


async function main() {
  //deploy col tokens

  const Weth = await ethers.getContractFactory("Weth");
  const weth = await Weth.deploy();
  await weth.deployed();

  const USDC = await ethers.getContractFactory("DSToken");
  const usdc = await USDC.deploy("USDC");
  await usdc.deployed("USDC");
  //
 let config = `
  module.exports.wethaddr = "${weth.address}"
    module.exports.usdcaddr = "${usdc.address}"

  `;

  let data = JSON.stringify(config);
  fs.appendFileSync("onboard_collateral.js", JSON.parse(data));
 
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
