require("@nomicfoundation/hardhat-toolbox");
const config = require("../../config.js");
const col = require("../../onboard_collateral.js");




async function main() {


  const dssDeploy = await (
    await ethers.getContractFactory("DssDeploy")
  ).attach(config.dssDeployaddress);


  const VatAddr = dssDeploy.vat();

  //deploy col joins
const symbol = col.token_symbol
const addr = col.token_addr


  const ColJoin = await ethers.getContractFactory("GemJoin");
  const coljoin = await ColJoin.deploy(VatAddr, symbol, addr); // * check inputs format
  await coljoin.deployed(VatAddr, symbol, addr);

  //deploy col pips

  const pipCol = await ethers.getContractFactory("DSValue");
  const pipcol = await pipCol.deploy(); // * check inputs format
  await pipcol.deployed();



  // init ilk and ilk's params for liqudition and auction


  const symbol_32 = ethers.utils.formatBytes32String(symbol);




  await dssDeploy.deployCollateralClip(
    symbol_32,
    coljoin.address,
    pipcol.address,
    ethers.constants.AddressZero
  );



  
  }

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
