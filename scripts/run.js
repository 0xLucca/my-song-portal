const main = async () => {
  const [owner ,randomPerson] = await hre.ethers.getSigners();
  const songContractFactory = await hre.ethers.getContractFactory('SongPortal');
  const songContract = await songContractFactory.deploy({
    value: hre.ethers.utils.parseEther('0.1'),
  });
  await songContract.deployed();
  console.log('Contract addy:', songContract.address);

  let contractBalance = await hre.ethers.provider.getBalance(
    songContract.address
  );

  console.log(
    'Contract balance:',
    hre.ethers.utils.formatEther(contractBalance)
  );

  /*
   * Let's try two shareSongs now
   */
  const shareSongTxn = await songContract.shareSong('This is Song #1');
  await shareSongTxn.wait();

  const shareSongTxn2 = await songContract.connect(randomPerson).shareSong('https://open.spotify.com/artist/6XyY86QOPPrYVGvF9ch6wz?si=98518697ee7e461c');
  await shareSongTxn2.wait();

  contractBalance = await hre.ethers.provider.getBalance(songContract.address);
  console.log(
    'Contract balance:',
    hre.ethers.utils.formatEther(contractBalance)
  );

  let allSongs = await songContract.getAllSongs();
  console.log(allSongs);
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