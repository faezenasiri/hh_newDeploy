require("@nomicfoundation/hardhat-toolbox");

async function main() {
  //deploy col tokens

  const Weth = await ethers.getContractFactory("Weth");
  const weth = await Weth.deploy();
  await weth.deployed();
  //const weth = await WETH.attach("0x1560dda51c176a7409573E05C57Dd417cA1c4256"); to use deployed

  const USDC = await ethers.getContractFactory("DSToken");
  const usdc = await USDC.deploy("USDC");
  await usdc.deployed("USDC");
  //

  const dssDeploy = await (
    await ethers.getContractFactory("DssDeploy")
  ).attach("0xb12BfaDaA2Bb030e97362F4bA4C525e3B63C1781");

  // * make sure to get the addr

  const VatAddr = dssDeploy.vat().address;

  //deploy col joins
  const ETHJoin = await ethers.getContractFactory("ETHJoin");
  const ethJoin = await ETHJoin.deploy(VatAddr, "ETH"); // * check inputs format
  await ethJoin.deployed(VatAddr, "ETH");

  const WethJoin = await ethers.getContractFactory("GemJoin");
  const wethjoin = await WethJoin.deploy(VatAddr, "Weth", weth.address); // * check inputs format
  await wethjoin.deployed(VatAddr, "ETH", weth.address);

  const USDCJoin = await ethers.getContractFactory("GemJoin");
  const usdcjoin = await USDCJoin.deploy(VatAddr, "USDC", usdc.address); // * check inputs format
  await usdcjoin.deployed(VatAddr, "USDC", usdc.address);

  //deploy col pips

  const pipETH = await ethers.getContractFactory("DSValue");
  const pipeth = await pipETH.deploy(); // * check inputs format
  await pipeth.deployed();

  const pipWeth = await ethers.getContractFactory("DSValue");
  const pipweth = await pipWeth.deploy(); // * check inputs format
  await pipweth.deployed();

  const pipUSDC = await ethers.getContractFactory("DSValue");
  const pipusdc = await pipUSDC.deploy(); // * check inputs format
  await pipusdc.deployed();

  // init ilk and ilk's params for liqudition and auction

  await dssDeploy.deployCollateralClip(
    "ETH",
    ethJoin.address,
    pipeth.address,
    ethers.constants.AddressZero
  );

  await dssDeploy.deployCollateralClip(
    "Weth",
    wethJoin.address,
    pipweth.address,
    ethers.constants.AddressZero
  );

  await dssDeploy.deployCollateralClip(
    "USDC",
    usdcjoin.address,
    pipusdc.address,
    ethers.constants.AddressZero
  );

  // Set Params
  await vat.file("Line", uint256(10000 * 10 ** 45));
  await vat.file("ETH", "line", uint256(10000 * 10 ** 45));
  await vat.file("Weth", "line", uint256(10000 * 10 ** 45));
  await vat.file("USDC", "line", uint256(10000 * 10 ** 45));
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
