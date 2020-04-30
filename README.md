# Contact Tracing on Blockchain - Smart Contracts

This repository contains the implementation of the smart contract discussed in [Contact Tracing on Blockchain](https://github.com/parthenopeblockchaingroup/contact-tracing-on-blockchain-docs).

## How to use
The project is built using [@openzeppelin/cli](https://www.npmjs.com/package/@openzeppelin/cli) so you should install it:

```
npm install -g @openzeppelin/cli 
```

Local tests can be done using a local instance of [ganache-cli](https://www.npmjs.com/package/ganache-cli):

```
npm install -g ganache-cli
ganache-cli --deterministic
```

When the Ganache instance is running you can deploy the contract using `oz deploy` and interact with the instance using `oz call` and `oz send-tx`.

### Generating `r` and `keccak256(r)`
The project includes an utility to generate a secret and its hash:

```
node scripts/generate-code
```

(you need to install `web3` using `npm install web3`)
## Contribute

The project is open for contributions.
Contact us @ [parthenopeblockchaingroup@gmail.com](parthenopeblockchaingroup@gmail.com)
