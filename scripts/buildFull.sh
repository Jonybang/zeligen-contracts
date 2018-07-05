#! /bin/bash

ZeligenToken=ZeligenToken.sol
ZeligenReserve=ZeligenReserve.sol
Marketplace=Marketplace.sol
Bytes32ToString=Bytes32ToString.sol

output=full

truffle-flattener contracts/$ZeligenToken > $output/$ZeligenToken
truffle-flattener contracts/$ZeligenReserve > $output/$ZeligenReserve
truffle-flattener contracts/$Marketplace > $output/$Marketplace
truffle-flattener contracts/$Bytes32ToString > $output/$Bytes32ToString
