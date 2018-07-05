pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/lifecycle/Pausable.sol";
import "openzeppelin-solidity/contracts/lifecycle/Destructible.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

import "./ZeligenToken.sol";

contract Marketplace is Ownable, Pausable, Destructible {
    using SafeMath for uint256;

    ZeligenToken public token;
    address public seller;

    uint256 public timeToSellReserve;

    struct Auction {
        // Auction ID
        bytes32 id;
        // Price (in wei) for the published item
        uint256 price;
        // Price to buy reserve
        uint256 reservePrice;
        // Time when this sale ends
        uint256 expiresAt;
        // Is auction active
        bool active;
    }

    mapping (bytes32 => Auction) public auctionByType;

    struct Buy {
        // Buy ID
        bytes32 id;
        // Buyer
        address buyer;
        // Price (in wei) for the published item
        uint256 price;
        // Payed (in wei) for the published item
        uint256 payed;
        // Time when this sale ends
        uint256 expiresAt;
        // Is auction active
        bool sold;
    }

    mapping (uint256 => Buy) public buyByReserve;

    /* EVENTS */
    event AuctionCreated(
        bytes32 id,
        bytes32 indexed assetType,
        uint256 price,
        uint256 reservePrice,
        uint256 expiresAt
    );
    event AuctionFinished(
        bytes32 id,
        uint256 indexed assetId
    );
    event NewBuy(
        bytes32 id,
        uint256 indexed reserveId,
        address indexed buyer,
        uint256 payed,
        uint256 price
    );
    event PayBuy(
        bytes32 id,
        uint256 indexed reserveId,
        address indexed buyer,
        uint256 payed,
        uint256 totalPayed
    );

    constructor (address _token, address _seller) public {
        token = ZeligenToken(_token);
        seller = _seller;

        timeToSellReserve = 1 weeks;
    }

    function createAuction(bytes32 _assetType, uint256 _price, uint256 _reservePrice, uint256 _expiresAt) onlySeller {
        require(_price > 0);
        require(_price >= _reservePrice);
        require(_expiresAt > now.add(1 hours));

        bytes32 auctionId = keccak256(
            block.timestamp,
            _assetType,
            _price,
            _reservePrice
        );

        auctionByType[_assetType] = Auction({
            id: auctionId,
            price: _price,
            reservePrice: _reservePrice,
            expiresAt: _expiresAt,
            active: true
        });

        emit AuctionCreated(
            auctionId,
            _assetType,
            _price,
            _reservePrice,
            _expiresAt
        );
    }

    function buy(bytes32 assetType) public payable returns (uint256) {
        require(auctionByType[assetType].active);
        require(auctionByType[assetType].expiresAt > now);

        uint256 weiAmount = msg.value;

        require(weiAmount >= auctionByType[assetType].reservePrice);

        uint256 reserveId = token.mint(msg.sender, assetType);

        bytes32 buyId = keccak256(
            block.timestamp,
            msg.sender,
            reserveId,
            weiAmount
        );

        buyByReserve[reserveId] = Buy({
            id: buyId,
            buyer: msg.sender,
            price: auctionByType[assetType].price,
            payed: weiAmount,
            expiresAt: now.add(timeToSellReserve),
            sold: weiAmount >= auctionByType[assetType].price
        });

        emit NewBuy(
            buyId,
            reserveId,
            msg.sender,
            weiAmount,
            auctionByType[assetType].price
        );

        return reserveId;
    }

    function payToBuy(uint256 reserveId) public payable {
        require(buyByReserve[reserveId].payed > 0);
        require(buyByReserve[reserveId].expiresAt > now);

        uint256 weiAmount = msg.value;

        buyByReserve[reserveId].payed = buyByReserve[reserveId].payed.add(weiAmount);
        buyByReserve[reserveId].sold = weiAmount >= buyByReserve[reserveId].price;

        emit PayBuy(
            buyByReserve[reserveId].id,
            reserveId,
            msg.sender,
            weiAmount,
            buyByReserve[reserveId].payed
        );
    }

    function isSold(uint256 tokenId) returns(bool) {
        return buyByReserve[tokenId].sold;
    }

    function buyerOf(uint256 tokenId) returns(address) {
        return buyByReserve[tokenId].buyer;
    }

    function setTimeToSellReserve(uint256 period) onlySeller {
        timeToSellReserve = period;
    }

    modifier onlySeller() {
        require(msg.sender == seller);
        _;
    }
 }
