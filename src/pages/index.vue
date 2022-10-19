<script setup lang="ts">
import { storeToRefs } from 'pinia'
import { ref } from 'vue'
import crypto_, { useCryptoStore } from '../store/crypto'

// 引用crypto.vue的const宣告變數
// import crypto_ from '../store/user'

const defineStore = useCryptoStore()
const { mint, deposit, itemcost, onSign, connectWallet } = useCryptoStore()
const { account, showTWDtoGwei, TWDtoEth, showdepositTxn } = storeToRefs(defineStore)

const getAmount = ref(0)
const amountInput = ref(null as any)
</script>

<template>
  <div class="flex flex-col items-center">
    <h1 class="text-2xl m-4">
      Get NFT !
    </h1>
    <button v-if="!account" class="bg-amber-600 rounded p-4" @click="connectWallet">
      Connect Wallet
    </button>

    <div v-if="account" class="border shadow w-4/12 p-4 mt-10">
      <button @click="onSign">
        Sign with Metamask
      </button>
      <P>Message : HelloWorld</P>
      <div style="word-break: break-all;">
        <p class="m-4">
          Signature : {{ crypto_.Sig }}
        </p>
      </div>

      <input
        v-model="getAmount"
        :style="{ width: '100px' }"
        name="AmountInfo"
        class="py-4 px-4 shadow border rounded"
        maxlength="15"
      >

      <button class="bg-cyan-500 rounded p-4 mt-10" @click="itemcost(getAmount)">
        cost
      </button>

      <p>Show TWD to Gwei: {{ showTWDtoGwei }}</p>

      <button class="bg-cyan-400 rounded p-4 mt-10" @click="deposit()">
        deposit
      </button>

      <p>Show TWD to Eth: {{ TWDtoEth }}</p>
      <p>{{ showdepositTxn }}</p>

      <br><span>How many you want to mint ? &emsp;</span>
      <input
        v-model.number="amountInput"
        type="number"
        :style="{ width: '100px' }"
        name="NFTBookInfo"
        class="py-4 px-4 shadow border rounded"
        maxlength="2"
      >
      <button class="bg-cyan-500 rounded p-4 mt-10" @click="mint(account, amountInput)">
        Mint
      </button>
    </div>
  </div>
</template>

<route lang="yaml">
meta:
  layout: home
</route>
