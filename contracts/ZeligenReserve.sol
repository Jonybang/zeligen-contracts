pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

contract ZeligenReserve is ERC721Token, Ownable {
    using SafeMath for uint256;

    string public constant _name = "Zeligen Reserve";

    string public constant _symbol = "ZLNR";

    constructor() public ERC721Token(_name, _symbol) {

    }

    function mint(address _to, uint256 _tokenId) public onlyOwner {
        super._mint(_to, _tokenId);
    }

    function burn(address _from, uint256 _tokenId) public onlyOwner {
        super._burn(_from, _tokenId);
    }

    function isApproved (address _operator, uint256 _tokenId) public returns (bool) {
        return super.isApprovedForAll(msg.sender, _operator) || super.getApproved(_tokenId) == _operator;
    }
}

