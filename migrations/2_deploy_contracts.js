const fs = require('fs');

const ZeligenTokenContract = artifacts.require('../full/ZeligenToken.sol'),
    ZeligenReserveContract = artifacts.require('../full/ZeligenReserve.sol'),
    MarketplaceContract = artifacts.require('../full/Marketplace.sol'),
    Bytes32ToStringContract = artifacts.require('../full/Bytes32ToString.sol');

module.exports = function (deployer, network, accounts) {
    // https://github.com/trufflesuite/truffle/issues/501
    deployer.then(async () => {
        const wallet = accounts[0],
            price = 500000;

        // await deployer.deploy(Bytes32ToStringContract);

        const zeligenToken = await deployer.deploy(ZeligenTokenContract, {
            gas: 7500000
        });

        let marketplace = await MarketplaceContract.at(await zeligenToken.marketplace());
        let reserve = await ZeligenReserveContract.at(await zeligenToken.reserve());

        await marketplace.createAuction("Howard", price, price/2, new Date().getTime() + 1000 * 3600 * 24);

        console.log('marketplace.auctionByType', await marketplace.auctionByType("Howard"));

        const tokenId = await marketplace.buy(["Howard"], {
            from: wallet,
            value: price
        });

        console.log('zeligenToken.marketplace.buyByReserve', await marketplace.buyByReserve(tokenId));

        console.log('zeligenToken.reserve.ownerOf', await reserve.ownerOf(tokenId));

        // await galt.mint(galtSaleContract.address, galt_sale_count);

        const gitRepo = "jonybang/zeligen-contracts";
        const buildDirPath = "https://raw.githubusercontent.com/" + gitRepo + "/master/build/contracts/";

        return new Promise((resolve, reject) => {
            fs.writeFile(__dirname + '/../data/contracts.json', JSON.stringify({
                ownerAddress: wallet,
                zeligenTokenAddress: zeligenToken.address,
                zeligenTokenBuildUrl:  buildDirPath + "ZeligenToken.json"
            }, null, 2), resolve);
        });
    })
};
