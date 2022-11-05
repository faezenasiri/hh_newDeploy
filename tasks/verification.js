require("@nomicfoundation/hardhat-toolbox");

async function main() {
  const USDC = await ethers.getContractFactory("DSToken");
  const usdc = await USDC.deploy("USDC");
  await usdc.deployed("USDC");

  const WAIT_BLOCK_CONFIRMATIONS = 6;
  await usdc.deployTransaction.wait(WAIT_BLOCK_CONFIRMATIONS);

  console.log(`Contract deployed to ${usdc.address} on ${network.name}`);

  console.log(`Verifying contract on Etherscan...`);
  const arg = ethers.utils.formatBytes32String("USDC");
  await run(`verify:verify`, {
    address: usdc.address,
    constructorArguments: arg,
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
