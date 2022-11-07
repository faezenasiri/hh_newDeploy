const config = require("../config.js");
//import { kj } from "./config.js";
async function main() {
  dssDeployaddre = config.kj;
  console.log(config.ll);
  //const dssDeploy = await ( await ethers.getContractFactory("DssDeploy")).attach(dssDeployaddre);

  //const co = await dssDeploy.vat();
  //const vat = await (await ethers.getContractFactory("Vat")).attach(co);
  //await vat.rely("0x3607C1Cf8122b659B919A5294007eA0785744086");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
