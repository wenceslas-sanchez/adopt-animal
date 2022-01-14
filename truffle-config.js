require("dotenv").config();
const HDWalletProvider = require("@truffle/hdwallet-provider");

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 7545,
      network_id: "*", // match any network
    },
    develop: {
      host: "localhost",
      port: 7545,
      network_id: "*", // match any network
    },
    mynetwork: {
      host: "localhost",
      port: 7545,
      network_id: "*", // match any network
    },
    ropsten: {
      provider: function () {
        return new HDWalletProvider(
          process.env.MNEMONIC,
          `https://:${process.env.PROJECT_SECRET}@ropsten.infura.io/v3/${process.env.PROJECT_ID}`,
          1
        );
      },
      network_id: 3,
      from: "0x00A010F72B6385b374b691f9d012286454C82b77",
    },
  },
  compilers: {
    solc: {
      version: "0.8.11",
    },
  },
};
