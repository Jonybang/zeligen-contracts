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

## Get space entity
```
const SpaceRegistry = artifacts.require('SpaceRegistry');
const landRegistryProxyAddress = "0x2990058a7c971e004b2c019dbe5ff73dfcde03ce";
const space = await SpaceRegistry.at(landRegistryAddress);
```

## Assign(and create) parcel to address
```
let parcel = {x: 1, y: 2, address: "0xf0430bbb78c3c359c22d4913484081a563b86170"};
const transaction = await land.assignNewParcel.sendTransaction(
    parcel.x,
    parcel.y,
    parcel.address,
    {
        gas: 1e6
    }
)

```

## Check parcel assigned to owner
```
const ownerAddress = await space.ownerOfSpace(1, 2);
```

## Get coordinates of parcels, which belongs to owner
```
const [x, y] = await space.landOf(ownerAddress)
```
