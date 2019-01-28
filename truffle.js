/* For macOS and Linux Users */

/* uncomment to deploy on rinkeby testnet
const HDWalletProvider = require('truffle-hdwallet-provider');
const infuraKey = "fj4jll3k....."; //replace it with your infura key

const fs = require('fs');
const mnemonic = fs.readFileSync(".secret").toString().trim();
*/

module.exports = {
  migrations_directory: "./migrations",
  solc: {
    optimizer: {
      enabled: true,
      runs: 2000
    }
  },
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*" // Match any network id
    },
    /*
    ropsten: {
      host: "127.0.0.1",
      port: 8545,
      network_id: 3,
      from: "0xe7d6c3f43d7859d7d6d045f9ac460eedffd3eae6" // replace with your Testnet account address
    },
    */
    /* uncomment to deploy on rinkeby testnet
    rinkeby: {
      provider: () => new HDWalletProvider(mnemonic, `https://rinkeby.infura.io/${infuraKey}`),
      network_id: 4,          // Rinkeby's id
      gas: 5500000,        
    },
    */
  }
};
