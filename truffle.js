require('babel-register');
require('babel-polyfill');

module.exports = {
  networks: {
    livenet: {
      host: "localhost",
      port: 8545,
      gas: 70000000,
      network_id: "*" // Match any network id
    },
    development: {
      host: "localhost",
      port: 8545,
      gas: 5000000,
      gasPrice: 10000000000,
      network_id: "*" // Match any network id
    },
    ropsten: {
      host: "localhost",
      port: 8545,
      network_id: 3, // official id of the ropsten network
      gas: 30000000
    }
  }
};
