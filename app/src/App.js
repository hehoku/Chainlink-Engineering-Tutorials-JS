import './App.css'
import React, { useEffect, useState } from 'react'
import contract from './contract/Lottery.json'

const contractAddress = '0xa8a7a9167c62a49bf9a926c75c41779200d1edc7'
const abi = contract.abi

const networks = {
  1: 'Mainnet',
  3: 'Ropsten',
  4: 'Rinkeby',
  80001: 'Polygon Mumbai Testnet'
}

function App () {
  const [currentAccount, setCurrentAccount] = useState(null)
  const [chainId, setChainId] = useState('')

  const checkWalletIsConnected = () => {
    const { ethereum } = window
    if (!ethereum) {
      console.log('🌏 Make sure you have Wallet installed')
      alert('You have not install wallet')
      return
    } else {
      console.log('🌈Wallet is connected')
    }
  }

  const connectWalletHandler = async () => {
    const { ethereum } = window
    if (!ethereum) {
      alert('You have not install wallet')
    }
    try {
      const accounts = await ethereum.request({
        method: 'eth_requestAccounts'
      })
      if (accounts.length > 0) {
        console.log('🌈Found an account:🤖', accounts[0])
        console.log('🌈 you')
      } else {
        console.log('🌈 there no account connected')
      }
      setCurrentAccount(accounts[0])
    } catch (err) {
      console.log(err)
    }
  }

  const getNetworkId = async () => {
    const { ethereum } = window
    if (!ethereum) {
      alert('You have not install wallet')
    }
    try {
      let networkId = await ethereum.request({
        method: 'eth_chainId'
      })
      console.log('🌈Network ID:', parseInt(networkId, 16))
      setChainId(parseInt(networkId, 16))
    } catch (err) {
      console.log(err)
    }
  }

  const formatAddress = address => {
    return (
      address.substring(0, 6) + '...' + address.substring(address.length - 4)
    )
  }

  const switchChain = async () => {
    const { ethereum } = window
    if (!ethereum) {
      alert('You have not install wallet')
    }
    try {
      let networkId = await ethereum.request({
        method: 'eth_chainId'
      })
      console.log('🌈Network ID:', parseInt(networkId, 16))
      if (networkId !== 80001) {
        await ethereum.request({
          method: 'wallet_switchEthereumChain',
          params: [{ chainId: `0x${Number(80001).toString(16)}` }]
        })
        networkId = await ethereum.request({
          method: 'eth_chainId'
        })
        setChainId(parseInt(networkId, 16))
      }
    } catch (err) {
      console.log(err)
    }
  }

  useEffect(() => {
    checkWalletIsConnected()
    connectWalletHandler()
    getNetworkId()
  }, [])

  return (
    <div className='flex h-screen w-full flex-col items-center justify-center bg-blue-500 align-middle'>
      <p className='text-center text-3xl font-bold text-white'>
        Hello, {currentAccount && formatAddress(currentAccount)}
      </p>
      <p className='text-center text-3xl font-bold text-white'>
        Network ID: {chainId}
      </p>
      <p className='text-center text-3xl font-bold text-white'>
        Network: {networks[chainId]}
      </p>
      {chainId !== 80001 && (
        <button
          onClick={switchChain}
          className='mt-8 rounded-md bg-white py-2 px-4'
        >
          Switch Chain
        </button>
      )}
    </div>
  )
}

export default App
