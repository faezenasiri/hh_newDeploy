require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */

// const infuraId = fs.readFileSync(".infuraid").toString().trim() || "";
// url : 'https://goerli.infura.io/v3/dfbc96c690a64a718e7dc88686efb668',

//const ALCHEMY_API_KEY = "pD54ockObabdkc18OPKVmp23DGSGlykS";

const GOERLI_PRIVATE_KEY =
  "ab535503c6cfce77ebe9bb14d751be9aacf1ceb469bf09f574c47ae52cb9e2fa";
//"e566b9c3394fb01a4f264fd8142229a834c51d9f816284e9d5c7f892d2feb136"
//"ab535503c6cfce77ebe9bb14d751be9aacf1ceb469bf09f574c47ae52cb9e2fa";
//"465a78dcdb6c0283d0674f827e82414b8f38f68c9f4920bcd9d2a8bfb15d310e"
//url : 'https://eth-goerli.g.alchemy.com/v2/pD54ockObabdkc18OPKVmp23DGSGlykS',
// url: `https://eth-goerli.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,

// url: "https://goerli.infura.io/v3/dfbc96c690a64a718e7dc88686efb668",
// url: "https://goerli.infura.io/v3/83af4d404170428f866ad492288eafac",
//url: "https://eth-goerli.g.alchemy.com/v2/pD54ockObabdkc18OPKVmp23DGSGlykS",
//url : 'wss://goerli.infura.io/ws/v3/0c075633f061442198efb3a765be0ad9',
// timeout: 20000,

module.exports = {
  solidity: {
    version: "0.6.12",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1,
      },
    },
  },
  networks: {
    goerli: {
      chainId: 5,
      url: "https://goerli.infura.io/v3/dfbc96c690a64a718e7dc88686efb668",
      accounts: [GOERLI_PRIVATE_KEY],
      timeout: 200000,
    },
  },
};
