/* eslint-disable no-alert */
/* eslint-disable no-console */
import { ethers } from 'ethers'
import { acceptHMRUpdate, defineStore } from 'pinia'

import { ref } from 'vue'
import contractABI from '../artifacts/contracts/SimplePay.sol/SimplePay.json'
const contractAddress = '0xe6a18A16FB0dad8f7516fb9848879C4E2036a178'

const Sig = ref()
// 預設匯出 !重要
export default {
  Sig,
}

export const useCryptoStore = defineStore('user', () => {
  const account = ref(null)
  const loading = ref(false)
  const Amount = ref(0)

  async function getBalance() {
    setLoader(true)
    try {
      const { ethereum } = window
      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum)
        const signer = provider.getSigner()
        const SimplePayContract = new ethers.Contract(contractAddress, contractABI.abi, signer)

        const count = (await SimplePayContract.getBalance())
        const amt = ethers.utils.formatEther(count)
        console.log('count', amt)
        setLoader(false)
      }
    }
    catch (e) {
      setLoader(false)
      console.log('e', e)
    }
  }

  // ------------------------------------------------------
  async function cost(TWDtoWei: any) {
    console.log('setting loader')
    setLoader(true)
    try {
      const { ethereum } = window
      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum)
        const signer = provider.getSigner() // 持有使用者的私鑰並以此簽核 (Signer)
        const SimplePayContract = new ethers.Contract(contractAddress, contractABI.abi, signer)

        TWDtoWei = TWDtoWei / 50000 * 1000000000000000000
        const costInput = await SimplePayContract.cost(TWDtoWei)

        console.log('loading....', costInput)
        await costInput.wait()
        console.log('loaded -- ', costInput)
      }
      else {
        console.log('Ethereum object doesn\'t exist!')
      }
    }
    catch (error) {
      setLoader(false)
      console.log(error)
    }
  }

  async function deposit() {
    console.log('setting loader')
    setLoader(true)
    try {
      const { ethereum } = window
      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum)
        const signer = provider.getSigner() // 持有使用者的私鑰並以此簽核 (Signer)
        const SimplePayContract = new ethers.Contract(contractAddress, contractABI.abi, signer)

        const depositTxn = await SimplePayContract.deposit(Sig)

        console.log('loading....', depositTxn)
        await depositTxn.wait()
        console.log('loaded -- ', depositTxn)
      }
      else {
        console.log('Ethereum object doesn\'t exist!')
      }
    }
    catch (error) {
      setLoader(false)
      console.log(error)
    }
  }

  // --------------------------------------------------------------

  // --------------------------------------------------------------

  async function connectWallet() {
    try {
      const { ethereum } = window
      if (!ethereum) {
        alert('Must connect to MetaMask!')
        return
      }

      // 授權獲取帳戶
      const myAccounts = await ethereum.request({ method: 'eth_requestAccounts' })

      console.log('Connected: ', myAccounts[0])
      account.value = myAccounts[0]

      await getBalance()
      await onSign()
    }
    catch (error) {
      console.log(error)
    }
  }

  // 客戶端進行鏈下簽名
  async function onSign() {
    try {
      // 1. 建構 Provider
      const { ethereum } = window
      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum)
        const signer = provider.getSigner()
        // const UDPCContract = new ethers.Contract(contractAddress, contractABI.abi, signer)

        // 2. 簽名內容 進行 solidity Keccak256 Hash
        const messageHsh = ethers.utils.solidityKeccak256(['string'], ['HelloWorld'])

        // 3. 轉成 bytes
        const arrayifyMessage = ethers.utils.arrayify(messageHsh)

        // 4. 使用私鑰進行消息簽名
        const Signature = await signer.signMessage(arrayifyMessage)
        Sig.value = Signature
      }
    }
    catch (error) {
      console.log(error)
    }
  }

  // ------------------------------------------------

  function setLoader(value: boolean) {
    console.log('setloader', value)
    loading.value = value
  }

  return {
    setLoader,
    loading,
    connectWallet,
    account,
    Amount,
    Sig,
    onSign,
    cost,
    deposit,
  }
})

if (import.meta.hot)
  import.meta.hot.accept(acceptHMRUpdate(useCryptoStore, import.meta.hot))
