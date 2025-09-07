// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title ProjectAccess1155 (Soulbound)
 * @notice Non-transferable ERC-1155 where tokenId encodes (projectId, roleId).
 *         Mint/burn controlled by MINTER_ROLE. Transfers are blocked.
 */
contract ProjectAccess1155 is ERC1155, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    string public name;
    string public symbol;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _uri,
        address admin
    ) ERC1155(_uri) {
        name = _name;
        symbol = _symbol;
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(MINTER_ROLE, admin);
    }

    function mint(address to, uint256 tokenId, uint256 amount)
        external
        onlyRole(MINTER_ROLE)
    {
        _mint(to, tokenId, amount, "");
    }

    function mintBatch(address[] calldata recipients, uint256 tokenId)
        external
        onlyRole(MINTER_ROLE)
    {
        for (uint256 i = 0; i < recipients.length; i++) {
            _mint(recipients[i], tokenId, 1, "");
        }
    }

    function burn(address from, uint256 tokenId, uint256 amount)
        external
        onlyRole(MINTER_ROLE)
    {
        _burn(from, tokenId, amount);
    }

    // Soulbound: block transfers except mint (from=0) and burn (to=0)
    function _update(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values
    ) internal virtual override {
        if (from != address(0) && to != address(0)) {
            revert("ProjectAccess1155: transfers disabled (soulbound)");
        }
        super._update(from, to, ids, values);
    }

    // Required when inheriting both ERC1155 and AccessControl (OZ v5)
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC1155, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
