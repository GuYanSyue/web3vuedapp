/** @type import('hardhat/config').HardhatUserConfig */
require('dotenv').config()
require('@nomiclabs/hardhat-waffle')

module.exports = {
  defaultNetwork: 'rinkeby',
  solidity: '0.8.4',
  paths: {
    artifacts: './src/artifacts',
  },

  networks: {
    hardhat: {
    },

    rinkeby: {
      url: 'https://eth-rinkeby.alchemyapi.io/v2/CoUToPs4z5EB2ewy35iE1KfOvwYBJ7o9',
      accounts: ['0x01e12448f4ab31997bb38a923c9c628e8a4dd61b4226403207a22d7161fa58a0'],
    },
  },
}

