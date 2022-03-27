const { expect } = require('chai')
const { ethers } = require('hardhat')

describe('Lottery contract entranceFee', function () {
  it('it should return entranceFee', async function () {
    const [owner] = await ethers.getSigners()

    const LotteryContract = await ethers.getContractFactory('Lottery')

    const contract = await LotteryContract.deploy()

    const entranceFee = await contract.getEntranceFee()
    console.log(entranceFee)
  })
})
