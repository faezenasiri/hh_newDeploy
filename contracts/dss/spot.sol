// SPDX-License-Identifier: AGPL-3.0-or-later

/// spot.sol -- Spotter

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

pragma solidity ^0.6.12;

// FIXME: This contract was altered compared to the production version.
// It doesn't use LibNote anymore.
// New deployments of this contract will need to include custom events (TO DO).

interface VatLike {
    function file(
        bytes32,
        bytes32,
        uint256
    ) external;
}

interface PipLike {
    function peek() external returns (bytes32, bool);
}

contract Spotter {
    // ---  ---
    mapping(address => uint256) public wards;

    function rely(address guy) external {
        wards[guy] = 1;
    }

    function deny(address guy) external {
        wards[guy] = 0;
    }

    // --- Data ---
    struct Ilk {
        PipLike pip; // Price Feed
        uint256 mat; // Liquidation ratio [ray]
    }

    mapping(bytes32 => Ilk) public ilks;

    VatLike public vat; // CDP Engine
    uint256 public par; // ref per irdt [ray]

    uint256 public live;

    // --- Events ---
    event Poke(
        bytes32 ilk,
        bytes32 val, // [wad]
        uint256 spot // [ray]
    );

    event File(bytes32 indexed ilk, bytes32 indexed what, uint256 data);
    event File(bytes32 indexed ilk, bytes32 indexed what, address pip_);
    event File(bytes32 what, uint256 data);

    // --- Init ---
    constructor(address vat_) public {
        wards[msg.sender] = 1;
        vat = VatLike(vat_);
        par = ONE;
        live = 1;
    }

    // --- Math ---
    uint256 constant ONE = 10**27;

    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require(y == 0 || (z = x * y) / y == x);
    }

    function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = mul(x, ONE) / y;
    }

    // --- Administration ---
    function file(
        bytes32 ilk,
        bytes32 what,
        address pip_
    ) external {
        require(live == 1, "Spotter/not-live");
        if (what == "pip") ilks[ilk].pip = PipLike(pip_);
        else revert("Spotter/file-unrecognized-param");
        emit File(ilk, what, pip_);
    }

    function file(bytes32 what, uint256 data) external {
        require(live == 1, "Spotter/not-live");
        if (what == "par") par = data;
        else revert("Spotter/file-unrecognized-param");
        emit File(what, data);
    }

    function file(
        bytes32 ilk,
        bytes32 what,
        uint256 data
    ) external {
        require(live == 1, "Spotter/not-live");
        if (what == "mat") ilks[ilk].mat = data;
        else revert("Spotter/file-unrecognized-param");
        emit File(ilk, what, data);
    }

    // --- Update value ---
    function poke(bytes32 ilk) external {
        (bytes32 val, bool has) = ilks[ilk].pip.peek();
        uint256 spot = has
            ? rdiv(rdiv(mul(uint256(val), 10**9), par), ilks[ilk].mat)
            : 0;
        vat.file(ilk, "spot", spot);
        emit Poke(ilk, val, spot);
    }

    function cage() external {
        live = 0;
    }
}