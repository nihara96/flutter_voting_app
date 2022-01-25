module.exports = {
    networks: {
     development: {
      host: "192.168.8.156",     // Localhost (default: none)
      port: 7545,            // Standard Ethereum port (default: none)
      network_id: "*",       // Any network (default: none)
     },
    // Another network with more advanced options...
     advanced: {       // Account to send txs from (default: accounts[0])
     websockets: true        // Enable EventEmitter interface for web3 (default: false)
     },
  },

  contracts_build_directory: "./src/abis/",

  // Configure your compilers
  compilers: {
    solc: {       // See the solidity docs for advice about optimization and evmVersion
        optimizer: {
          enabled: true,
          runs: 200
        },
    }
  }
};
