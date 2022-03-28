const { expect } = require('chai')
const { ethers } = require('hardhat')
const Web3 = require('web3')

describe('Lottery contract entranceFee', function () {
  it('it should return entranceFee', async function () {
    const [owner] = await ethers.getSigners()

    const LotteryContract = await ethers.getContractFactory('Lottery')

    const contract = await LotteryContract.deploy()

    const entranceFee = await contract.getEntranceFee()
    // entranceFee should be greater than 0.015 ethers
    const entranceFeeValue = await Web3.utils.fromWei(
      entranceFee.toString(),
      'ether'
    )
    expect(entranceFeeValue > 0.015)
  })
})
