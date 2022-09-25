const hre = require('hardhat')

async function main() {
  const [deployer] = await hre.ethers.getSigners()

  console.log(
    'Deploying contracts with the account:',
    deployer.address,
  )

  const SimplePay = await hre.ethers.getContractFactory('SimplePay')
  const spay = await SimplePay.deploy()

  await spay.deployed()

  console.log('payment deployed to:', spay.address)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
