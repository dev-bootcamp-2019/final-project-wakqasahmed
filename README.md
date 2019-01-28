# Basic dApp Marketplace

## Introduction

This project is part of the assessment requirement of *2018DP Ethereum Developer Bootcamp*. It allows sellers to list their items, ship and claim funds (of their sold items in ether) and buyers to buy items by paying in ether and acknowledge on receiving the items.

![Basic dApp Marketplace Flowchart](./dapp_flowchart.jpg)

## Pre-requisites

1. NodeJS (version 8.9.x)
2. Webpack
```
    npm install -g webpack
    npm install -g webpack-cli
```
3. Truffle
```
    npm install -g truffle
```
4. Ganache from [Truffle Website](!https://truffleframework.com/ganache)
```
    npm install -g ganache-cli
```
5. Install the application
```
    npm install
```

## How to run

1. Open a terminal, *run `ganache-cli` and keep it running*
2. Open another (2nd) terminal and run the following:
```
    $ git clone https://github.com/dev-bootcamp-2019/final-project-wakqasahmed.git
    $ cd final-project-wakqasahmed
```

3. To interact with smart contract from CLI:
```
    $ truffle compile --reset
    $ truffle migrate --reset
    $ truffle test
```

OR

```
    truffle develop
    develop> compile --reset
    develop> migrate --reset
    develop> test
```

You should see the following:

```
  TestMerchandise
    ✓ testAddItem (90ms)
    ✓ testGetItem (153ms)
    ✓ testBuyItem (59ms)
    ✓ testShipItem (63ms)

  Contract: Merchandise
    ✓ Should have the test item in the marketplace
    ✓ Should fail to ship if not bought (95ms)
```

### Executing (basic) marketplace transactions via CLI

```
truffle develop

#Pre-requisite (Truffle accounts that it listed)
develop> web3.eth.getAccounts()
#Accounts:
#(0) 0xf1f293a8481be4049191fd0592afaaad03f24a94 (Owner)
#(1) 0x06fb63cadc1e6fdb2791f95c83c85ce0d07adf07 (Seller)
#(2) 0x8c0534225e1556b3f4ceb987e4d9e0465144dd09 (Buyer)

#Getting contract address to interact with it
develop> var mktp = await Merchandise.at(Merchandise.address)
develop> mktp.address //should display contracts' address

#Getting and Adding an item
develop> mktp.getItem(0)
develop> mktp.addItem("Ledger Nano S", "Protect your funds", "1500000000000000000")
develop> mktp.getItem(0)
```

4. To access the dApp UI, run the following:
```
    npm start
```

## FAQ

* __Why is there both a truffle.js file and a truffle-config.js file?__

    Truffle requires the truffle.js file be named truffle-config on Windows machines. Feel free to delete the file that doesn't correspond to your platform.
