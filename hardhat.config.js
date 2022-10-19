/* eslint-disable @typescript-eslint/no-unused-vars */
/** @type import('hardhat/config').HardhatUserConfig */
require('dotenv').config()
require('@nomiclabs/hardhat-waffle')
require('@nomiclabs/hardhat-ethers')
const API_URL = 'https://goerli.infura.io/v3/'
const PRIVATE_KEY = ''
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
      accounts: [''],
    },
  },
}

