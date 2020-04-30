const Web3 = require('web3');

let randomBytes = Web3.utils.randomHex(32);
let hash = Web3.utils.soliditySha3({type: 'bytes', value: randomBytes});

console.log("r =            " + randomBytes);
console.log("Keccak256(r) = " + hash);
