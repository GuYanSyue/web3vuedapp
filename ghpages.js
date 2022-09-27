/* eslint-disable no-console */
// place at : deploy/ghpages.js
// you can see more info at https://github.com/tschaub/gh-pages
const path = require('path')
const ghpages = require('main')

const options = {
  branch: 'main',
  repo: 'https://github.com/GuYanSyue/web3vuedapp.git', // project github repo
}

const callback = (err) => {
  if (err)
    console.error(err)
  else console.log('publish success')
}

/**
 * This task pushes to the `master` branch of the configured `repo`.
 */
ghpages.publish(path.resolve(__dirname, '../dist'), options, callback)
