const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const songContractFactory = await hre.ethers.getContractFactory('SongPortal');
    const songContract = await songContractFactory.deploy();
    await songContract.deployed();
  
    console.log('Contract deployed to:', songContract.address);
    console.log('Contract deployed by:', owner.address);
  
    let songCount;
    songCount = await songContract.getTotalSongs();
  
    let songTxn = await songContract.shareSong();
    await songTxn.wait();
  
    songCount = await songContract.getTotalSongs();
  
    songTxn = await songContract.connect(randomPerson).shareSong();
    await songTxn.wait();
  
    songCount = await songContract.getTotalSongs();
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