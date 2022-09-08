// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Cryptonitro is ERC721URIStorage, Ownable {
    using SafeMath for uint;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    IERC20 private nitroxToken;

    string private baseURI;
    string public baseExtension = ".json";
    bool public paused = false;

    mapping (string => uint) public ownContainer;

    modifier onlyWhenNotPaused {
      require(!paused, "Contract currently paused");
      _;
    }

    constructor(string memory _name, string memory _symbol, string memory _initBaseURI) ERC721(_name, _symbol) { 
      baseURI = _initBaseURI;
      nitroxToken = IERC20(0x398f3E66E3bE2eC0B9a502cE87008436D3981e4A);
    }

    /* ****************** */
    /* INTERNAL FUNCTIONS */
    /* ****************** */

    function _baseURI() internal view virtual override returns (string memory) {
      return baseURI;
    }

    /* **************** */
    /* PUBLIC FUNCTIONS */
    /* **************** */

    function totalSupply() public view returns (uint) {
        return _tokenIds.current();
    }

    function tokenURI (uint tokenId) public view virtual override returns(string memory){
      require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
      string memory currentBaseURI = _baseURI(); 
      return bytes(currentBaseURI).length > 0
            ? string(
                abi.encodePacked(
                    currentBaseURI,
                    Strings.toString(tokenId),
                    baseExtension
                )
            )
            : "";
    }

    function mintItem(uint _cost, string memory _container) public onlyWhenNotPaused {
      uint tokenIdByContainer;
      if(keccak256(abi.encodePacked(_container)) == keccak256(abi.encodePacked("Common"))) {
        require(ownContainer[_container] + 1 <= 50000, "Maxium is 50000");
        tokenIdByContainer = 1 + ownContainer[_container];
      } else if (keccak256(abi.encodePacked(_container)) == keccak256(abi.encodePacked("Rare"))) {
        require(ownContainer[_container] + 1 <= 30000, "Maxium is 30000");
        tokenIdByContainer = 50001 + ownContainer[_container];
      } else if (keccak256(abi.encodePacked(_container)) == keccak256(abi.encodePacked("Epic"))) {
        require(ownContainer[_container] + 1 <= 15000, "Maxium is 15000");
        tokenIdByContainer = 80001 + ownContainer[_container];
      } else if (keccak256(abi.encodePacked(_container)) == keccak256(abi.encodePacked("Legendary"))) {
        require(ownContainer[_container] + 1 <= 5000, "Maxium is 5000");
        tokenIdByContainer = 95001 + ownContainer[_container];
      }
      nitroxToken.transferFrom(msg.sender, address(this), _cost);
      _tokenIds.increment();
      ownContainer[_container]++;
      _safeMint(msg.sender, tokenIdByContainer);
    }

    /* *************** */
    /* OWNER FUNCTIONS */
    /* *************** */

    function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
        baseExtension = _newBaseExtension;
    }

    function pause(bool _state) public onlyOwner {
        paused = _state;
    }

    function setCommonCost(uint _newCost) public onlyOwner {
        commonCost = _newCost;
    }

    function setRareCost(uint _newCost) public onlyOwner {
        rareCost = _newCost;
    }

    function setEpicCost(uint _newCost) public onlyOwner {
        epicCost = _newCost;
    }

    function setLegendaryCost(uint _newCost) public onlyOwner {
        legendaryCost = _newCost;
    }

    function withdraw() external onlyOwner {
      address _owner = owner();
      uint256 _amount = nitroxToken.balanceOf(address(this));
      nitroxToken.approve(_owner, _amount);
      nitroxToken.transfer(_owner, _amount);
    }
}