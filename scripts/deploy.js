async function main() {
  const MyOracle = await ethers.getContractFactory("OracleStreaming");
  // Start deployment, returning a promise that resolves to a contract object
  const myOracle = await MyOracle.deploy();
  await myOracle.deployed();
  console.log("Contract deployed to address:", myNFT.address);
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });