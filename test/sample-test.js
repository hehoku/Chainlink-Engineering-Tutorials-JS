const { expect } = require('chai')
const { ethers } = require('hardhat')

describe('SimpleStorage Test', function () {
  it("Should return the new greeting once it's changed", async function () {
    const SimpleStorage = await ethers.getContractFactory('SimpleStorage')
    const contract = await SimpleStorage.deploy()
    await contract.deployed()

    const setNumberTx = await contract.store(312)

    // wait until the transaction is mined
    await setNumberTx.wait()

    expect(await contract.retrieve()).to.equal(0)
  })
})
