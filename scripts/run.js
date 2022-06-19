const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  });
  await waveContract.deployed();

  console.log("Contract address:", waveContract.address);
  console.log("Contract deployed by wallet:", owner.address);

  /*
   * Get Contract balance
   */
  let contractBalance = await hre.ethers.provider.getBalance(
    waveContract.address
  );
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  const waveTxn = await waveContract.wave("hello friends");
  await waveTxn.wait();

  const waveTxn2 = await waveContract.wave("hello friends");
  await waveTxn2.wait();

  const randomWaveTxn = await waveContract
    .connect(randomPerson)
    .wave("hello builder");
  await randomWaveTxn.wait();

  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log(
    "New contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  waveCount = await waveContract.getAllWaves();

  console.log("Array of waves", waveCount);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
