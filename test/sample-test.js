const { expect } = require('chai')
const { ethers } = require('hardhat')
const Web3 = require('web3')

describe('Lottery contract entranceFee', function () {
  it('it should return entranceFee', async function () {
    const [owner] = await ethers.getSigners()
    const addresses = await ethers.getSigners()

    const LotteryContract = await ethers.getContractFactory('Lottery')

    const contract = await LotteryContract.deploy(
      '0x8c7382f9d8f56b33781fe506e897a4f1e2d17255',
      '0x326c977e6efc84e512bb9c30f76e30c160ed06fb',
      100000000000000,
      '0x6e75b569a01ef56d18cab6a8e71e6600d6ce853834d4a5748b720d06f878b3a4'
    )

    const entranceFee = await contract.getEntranceFee()
    // entranceFee should be greater than 0.015 ethers
    const entranceFeeValue = await Web3.utils.fromWei(
      entranceFee.toString(),
      'ether'
    )
    console.log('entranceFeeValue 🎫', entranceFeeValue)
    expect(entranceFeeValue > 0.015)

    console.log('contract deployed to address: 🤖 ', contract.address)
    console.log('contract owner address: 🤖 ', owner.address)
    console.log('address available counts: 🤖', addresses.length)
    for (const account of addresses) {
      console.log(account.address)
    }
  })
})
