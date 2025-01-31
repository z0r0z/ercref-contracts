// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "./AERC5453.sol";

contract EndorsableERC721 is ERC721, AERC5453Endorsible {
    mapping(address => bool) private owners;

    constructor()
        ERC721("ERC721ForTesting", "ERC721ForTesting")
        AERC5453Endorsible("EndorsableERC721", "v1")
    {
        owners[msg.sender] = true;
    }

    function addOwner(address _owner) external {
        require(owners[msg.sender], "EndorsableERC721: not owner");
        owners[_owner] = true;
    }

    function mint(
        address _to,
        uint256 _tokenId,
        bytes calldata _extraData
    )
        external
        onlyEndorsed(
            _computeFunctionParamHash(
                "function mint(address _to,uint256 _tokenId)",
                abi.encode(_to, _tokenId)
            ),
            _extraData
        )
    {
        _mint(_to, _tokenId);
    }

    function _isEligibleEndorser(
        address _endorser
    ) internal view override returns (bool) {
        return owners[_endorser];
    }
}
