const config = require("../config.js");

require("@nomicfoundation/hardhat-toolbox");

async function main() {
  const dssDeploy = await (
    await ethers.getContractFactory("DssDeploy")
  ).attach(config.dssDeployaddress);
  const WAIT_BLOCK_CONFIRMATIONS = 6;

  await dssDeploy.deployVat().wait(WAIT_BLOCK_CONFIRMATIONS);

  await dssDeploy.deployIRDT(config.chain_id).wait(WAIT_BLOCK_CONFIRMATIONS);
  await dssDeploy.deployTaxation().wait(WAIT_BLOCK_CONFIRMATIONS);
  await dssDeploy.deployAuctions(config.owner).wait(WAIT_BLOCK_CONFIRMATIONS);
  await dssDeploy.deployLiquidator().wait(WAIT_BLOCK_CONFIRMATIONS);
  await dssDeploy.deployEnd().wait(WAIT_BLOCK_CONFIRMATIONS);
  await dssDeploy.deployPause(config.pause_time, config.owner).wait(WAIT_BLOCK_CONFIRMATIONS);
  await dssDeploy.deployESM(config.owner, config.esm_time).wait(WAIT_BLOCK_CONFIRMATIONS);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
