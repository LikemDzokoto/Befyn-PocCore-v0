import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";

dotenv.config();

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.26",
    settings: {
      viaIR: true,
      optimizer: {
        enabled: true,
        runs: 99999,
      },
      evmVersion: "london",
    },
  },
  networks: {
    optimismTestnet: {
      url: "https://optimism-sepolia.infura.io/v3/82de4c56f4364dd899635d8ebbc349cc",
      chainId: 11155420,
      accounts: [process.env.PRIVATE_KEY!]
    },
    baseTestnet: {
      url: "https://base-sepolia.g.alchemy.com/v2/HRuE-rJDcTKRgtIMVUcPomOMjFTthkoi",
      chainId: 84532,
      accounts: [process.env.PRIVATE_KEY!]
    },
    sepoliaTestnet: {
      url: "https://eth-sepolia.g.alchemy.com/v2/x2hC9QfiIYGJf4mQWfu6bQgLvrOegki2",
      chainId: 11155111,
      accounts: [process.env.PRIVATE_KEY!]
    },

},

  etherscan: {
    apiKey: ETHERSCAN_KEY,
  },

};



export default config;
