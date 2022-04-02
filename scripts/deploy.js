// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require('hardhat')

async function main () {
  const LotteryContract = await hre.ethers.getContractFactory('Lottery')

  const contract = await LotteryContract.deploy(
    '0x8c7382f9d8f56b33781fe506e897a4f1e2d17255',
    '0x326c977e6efc84e512bb9c30f76e30c160ed06fb',
    100000000000000,
    '0x6e75b569a01ef56d18cab6a8e71e6600d6ce853834d4a5748b720d06f878b3a4'
  )

  await contract.deployed()

  console.log('🤖 Lottery contract deployed to:', contract.address)
  // 0xa8a7a9167c62a49bf9a926c75c41779200d1edc7
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error)
    process.exit(1)
  })
