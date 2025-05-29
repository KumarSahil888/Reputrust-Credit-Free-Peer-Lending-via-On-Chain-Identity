const hre = require("hardhat");

async function main() {
  const Reputrust = await hre.ethers.getContractFactory("Reputrust");
  const reputrust = await Reputrust.deploy();

  await reputrust.deployed();
  console.log("Reputrust contract deployed to:", reputrust.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Error deploying contract:", error);
    process.exit(1);
  });
