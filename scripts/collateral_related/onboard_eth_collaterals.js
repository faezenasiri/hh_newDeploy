require("@nomicfoundation/hardhat-toolbox");
const config = require("../../config.js");

async function main() {


  const dssDeploy = await (
    await ethers.getContractFactory("DssDeploy")
  ).attach(config.dssDeployaddress);

  // * make sure to get the addr

  const VatAddr = dssDeploy.vat().address;


  //deploy col joins
  const ETHJoin = await ethers.getContractFactory("ETHJoin");
  const ethJoin = await ETHJoin.deploy(VatAddr, "ETH"); // * check inputs format
  await ethJoin.deployed(VatAddr, "ETH");


  //deploy col pips

  const pipETH = await ethers.getContractFactory("DSValue");
  const pipeth = await pipETH.deploy(); // * check inputs format
  await pipeth.deployed();


  // init ilk and ilk's params for liqudition and auction

    const token1 = ethers.utils.formatBytes32String("ETH");
  const line = ethers.utils.formatBytes32String("line");
    const Line = ethers.utils.formatBytes32String("Line");





  await dssDeploy.deployCollateralClip(
    token1,
    ethJoin.address,
    pipeth.address,
    ethers.constants.AddressZero
  );

  const vatLine = config.vatLine


 const Line256 = ethers.BigNumber.from( vatLine) 

  const Vat = await (await ethers.getContractFactory("Vat")).attach(VatAddr);

  await Vat.file(Line,Line256);
  await Vat.file(token1, line,Line256);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
