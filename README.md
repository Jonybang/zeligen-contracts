# Space

Contracts for Andromeda's World.

## Overview

The Space contract keeps a record of all the land parcels, who their owner is,
and what data is associated with them. The data associated can be an IPFS
identifier, an IPNS url, or a simple HTTPS endpoint with a land description
file.

## Addresses in KOVAN (POA) TESTNET

See addresses in `data.json`

## How to deploy

```
npm i
npm i -g truffle truffle-flattener
./scripts/buildFull.sh
truffle migrate
```
