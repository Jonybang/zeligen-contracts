pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
//import "./Bytes32ToString.sol";
import "./ZeligenReserve.sol";
import "./Marketplace.sol";

contract ZeligenToken is ERC721Token, Ownable {
    using SafeMath for uint256;

    string public constant _name = "Zeligen";

    string public constant _symbol = "ZLN";

    mapping (uint256 => bytes32) public typeByAssetId;
    mapping (bytes32 => uint256) public countByType;

    ZeligenReserve public reserve;
    Marketplace public marketplace;

    constructor() public ERC721Token(_name, _symbol) {
        reserve = new ZeligenReserve();
        marketplace = new Marketplace(address(this), msg.sender);
    }

    function mint(address _to, bytes32 _type) public ownerOrMarketPlace returns (uint256) {
        uint256 _tokenId = totalSupply() + 1;
        typeByAssetId[_tokenId] = _type;
        countByType[_type] = countByType[_type].add(1);

        super._mint(address(this), _tokenId);

        reserve.mint(_to, _tokenId);
    }

    function exchangeReserveToToken(uint256 _tokenId) {
        assert(super.ownerOf(_tokenId) == address(this));
        assert(marketplace.isSold(_tokenId));

        super.transferFrom(address(this), marketplace.buyerOf(_tokenId), _tokenId);
        reserve.burn(marketplace.buyerOf(_tokenId), _tokenId);
    }

    function isApproved (address _operator, uint256 _tokenId) public returns (bool) {
        return super.isApprovedForAll(msg.sender, _operator) || super.getApproved(_tokenId) == _operator;
    }

    //function getTypeString(uint256 assetId) public returns (string) {
    //    return Bytes32ToString.bytes32ToStr(typeByAssetId[assetId]);
    //}

    modifier ownerOrMarketPlace() {
        require(msg.sender == owner || msg.sender == address(marketplace));
        _;
    }
}

