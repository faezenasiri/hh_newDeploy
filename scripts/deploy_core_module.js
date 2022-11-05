// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
require("@nomicfoundation/hardhat-toolbox");

async function main() {
  const dssDeploy = await (
    await ethers.getContractFactory("DssDeploy")
  ).attach("0xb12BfaDaA2Bb030e97362F4bA4C525e3B63C1781");

  await dssDeploy.deployVat();

  await dssDeploy.deployIRDT(5);
  await dssDeploy.deployTaxation();
  await dssDeploy.deployAuctions("0x386b1807a2454d02e3ad162af26f209a340f90f5");
  await dssDeploy.deployLiquidator();
  await dssDeploy.deployEnd();
  await dssDeploy.deployPause(0, "0x386b1807a2454d02e3ad162af26f209a340f90f5");
  await dssDeploy.deployESM("0x386b1807a2454d02e3ad162af26f209a340f90f5", 10);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
