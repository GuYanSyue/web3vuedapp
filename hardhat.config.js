/* eslint-disable @typescript-eslint/no-unused-vars */
/** @type import('hardhat/config').HardhatUserConfig */
require('dotenv').config()
require('@nomiclabs/hardhat-waffle')
require('@nomiclabs/hardhat-ethers')
const API_URL = 'https://goerli.infura.io/v3/'
const PRIVATE_KEY = '0x01e12448f4ab31997bb38a923c9c628e8a4dd61b4226403207a22d7161fa58a0'
const PUBLIC_KEY = '0x3b0933b5EB572e5C1baC6f8D568B16EDDDFfB502'

module.exports = {
  defaultNetwork: 'goerli',
  solidity: '0.8.4',
  paths: {
    artifacts: './src/artifacts',
  },

  networks: {
    hardhat: {
    },

    goerli: {
      url: 'https://eth-goerli.g.alchemy.com/v2/NBJYskJmiB1YFOjToOCS3PuZZkk4tLHW',
      accounts: ['0x01e12448f4ab31997bb38a923c9c628e8a4dd61b4226403207a22d7161fa58a0'],
    },
  },
}

