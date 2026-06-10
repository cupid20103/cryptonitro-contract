# Cryptonitro Contract

An ERC-721 NFT smart contract for the Cryptonitro collection. NFTs are minted across four rarity tiers, and minting is paid for with the NitroX ERC-20 token.

## Overview

`Cryptonitro` extends OpenZeppelin's `ERC721URIStorage` and `Ownable`. Each mint pulls a tier-specific price (in NitroX tokens) from the buyer, assigns a token ID from that tier's reserved range, and mints the NFT to the buyer.

## Rarity Tiers

Each tier has a fixed maximum supply and a reserved token ID range:

| Tier      | Max Supply | Token ID Range    |
|-----------|-----------:|-------------------|
| Common    | 50,000     | 1 to 50,000       |
| Rare      | 30,000     | 50,001 to 80,000  |
| Epic      | 15,000     | 80,001 to 95,000  |
| Legendary | 5,000      | 95,001 to 100,000 |

Total maximum supply across all tiers is 100,000 tokens.

## Payment Token

Minting is paid in the NitroX ERC-20 token, hardcoded in the constructor:

```
0x398f3E66E3bE2eC0B9a502cE87008436D3981e4A
```

Before minting, a buyer must approve the contract to spend the required amount of NitroX. The per-tier cost is set by the owner and read from on-chain state at mint time (it is not supplied by the caller).

## Contract Interface

### Public

- `mintItem(string _container)`: Mints one NFT in the given tier (`"Common"`, `"Rare"`, `"Epic"`, or `"Legendary"`). Pulls the tier cost in NitroX from the caller and reverts on an unknown tier. Disabled while paused.
- `totalSupply()`: Returns the total number of tokens minted so far.
- `tokenURI(uint tokenId)`: Returns the metadata URI for a token (`baseURI` + `tokenId` + `baseExtension`).
- `ownContainer(string)`: Returns how many tokens have been minted in a given tier.
- `commonCost`, `rareCost`, `epicCost`, `legendaryCost`: Current cost per tier.
- `baseExtension`, `paused`: Public configuration values.

### Owner Only

- `setCommonCost(uint)`, `setRareCost(uint)`, `setEpicCost(uint)`, `setLegendaryCost(uint)`: Set the cost per tier.
- `setBaseExtension(string)`: Set the metadata file extension (default `.json`).
- `pause(bool)`: Pause or unpause minting.
- `withdraw()`: Transfer the contract's full NitroX balance to the owner.

## Dependencies

- Solidity `^0.8.0`
- [OpenZeppelin Contracts](https://github.com/OpenZeppelin/openzeppelin-contracts) (`ERC721URIStorage`, `Ownable`, `Counters`, `Strings`, `IERC20`)

## Building

This repository contains the contract source only. To compile, test, or deploy it, add a development framework such as [Foundry](https://book.getfoundry.sh/) or [Hardhat](https://hardhat.org/) and install the OpenZeppelin dependency.

For example, with Foundry:

```bash
forge init --no-commit
forge install OpenZeppelin/openzeppelin-contracts
forge build
```

## License

MIT
