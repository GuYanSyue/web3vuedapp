<script setup lang="ts">
import { storeToRefs } from 'pinia'
import { ref } from 'vue'
import crypto_, { useCryptoStore } from '../store/crypto'

// 引用crypto.vue的const宣告變數
// import crypto_ from '../store/user'

const defineStore = useCryptoStore()
const { deposit, cost, onSign, connectWallet } = useCryptoStore()
const { account } = storeToRefs(defineStore)

const AmountTWD = ref(0)
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
        v-model="AmountTWD"
        :style="{ width: '100px' }"
        name="AmountInfo"
        class="py-4 px-4 shadow border rounded"
        maxlength="15"
      >

      <button class="bg-cyan-500 rounded p-4 mt-10" @click="cost(AmountTWD)">
        cost
      </button>

      <button @click="deposit()">
        deposit
      </button>
    </div>
  </div>
</template>

<route lang="yaml">
meta:
  layout: home
</route>
