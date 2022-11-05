require("@nomicfoundation/hardhat-toolbox");

async function main() {

  const Weth = await ethers.getContractFactory("Weth");
  const weth = await Weth.deploy();
  await weth.deployed();


        ethJoin = new GemJoin(address(vat), "ETH", address(weth));
        dssDeploy.deployCollateralFlip("ETH", address(ethJoin), address(pipETH));

       
        col2 = new DSToken("COL2");
        col2Join = new GemJoin(address(vat), "COL2", address(col2));
        LinearDecrease calc = calcFab.newLinearDecrease(address(this));
        calc.file(bytes32("tau"), 1 hours);

        dssDeploy.deployCollateralClip("COL2", address(col2Join), address(pipCOL2), address(calc));

        // Set Params
        this.file(address(vat), bytes32("Line"), uint(10000 * 10 ** 45));
        this.file(address(vat), bytes32("ETH"), bytes32("line"), uint(10000 * 10 ** 45));
        this.file(address(vat), bytes32("COL"), bytes32("line"), uint(10000 * 10 ** 45));
        this.file(address(vat), bytes32("COL2"), bytes32("line"), uint(10000 * 10 ** 45));

  const dssDeploy = await (
    await ethers.getContractFactory("DssDeploy")
  ).attach("0x1560dda51c176a7409573E05C57Dd417cA1c4256");


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

const weth = await WETH.attach("0x1560dda51c176a7409573E05C57Dd417cA1c4256");
