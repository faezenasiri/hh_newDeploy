require("@nomicfoundation/hardhat-toolbox");
const config = require("../../config.js");
const col = require("../../onboard_collateral.js");


async function main() {


  const dssDeploy = await (
    await ethers.getContractFactory("DssDeploy")
  ).attach(config.dssDeployaddress);


  const VatAddr = dssDeploy.vat().address;

    const Vat = await (await ethers.getContractFactory("Vat")).attach(VatAddr);



const symbol = col.token_symbol
const Line = col.token_line


    const symbol_32 = ethers.utils.formatBytes32String(symbol);







 const line = ethers.BigNumber.from( Line) 

  // Set Params
  await Vat.file(symbol_32, line,Line256);


  

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

