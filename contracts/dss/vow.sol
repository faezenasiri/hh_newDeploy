// SPDX-License-Identifier: AGPL-3.0-or-later

/// vow.sol -- IRDT settlement module

// Copyright (C) 2018 Rain <rainbreak@riseup.net>
//
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

interface FlopLike {
    function kick(
        address gal,
        uint256 lot,
        uint256 bid
    ) external returns (uint256);

    function cage() external;

    function live() external returns (uint256);
}

interface FlapLike {
    function kick(uint256 lot, uint256 bid) external returns (uint256);

    function cage(uint256) external;

    function live() external returns (uint256);
}

interface VatLike {
    function irdt(address) external view returns (uint256);

    function sin(address) external view returns (uint256);

    function heal(uint256) external;

    function hope(address) external;

    function nope(address) external;
}

contract Vow {
    // --- Auth ---
    mapping(address => uint256) public wards;

    function rely(address usr) external {
        require(live == 1, "Vow/not-live");
        wards[usr] = 1;
        emit Rely(usr);
    }

    function deny(address usr) external {
        wards[usr] = 0;
        emit Deny(usr);
    }

    // --- Data ---
    VatLike public vat; // CDP Engine
    FlapLike public flapper; // Surplus Auction House
    FlopLike public flopper; // Debt Auction House

    mapping(uint256 => uint256) public sin; // debt queue
    uint256 public Sin; // Queued debt            [rad]
    uint256 public Ash; // On-auction debt        [rad]

    uint256 public wait; // Flop delay             [seconds]
    uint256 public dump; // Flop initial lot size  [wad]
    uint256 public sump; // Flop fixed bid size    [rad]

    uint256 public bump; // Flap fixed lot size    [rad]
    uint256 public hump; // Surplus buffer         [rad]

    uint256 public live; // Active Flag

    event Rely(address indexed usr);
    event Deny(address indexed usr);

    event File(bytes32 indexed what, uint256 data);
    event File(bytes32 indexed what, address data);
    event Fess(uint256 indexed tab);
    event Flog(uint256 indexed era);
    event Heal(uint256 indexed rad);

    event Kiss(uint256 indexed rad);
    event Flop(uint256 indexed id);
    event Flap(uint256 indexed id);

    event Cage();

    // --- Init ---
    constructor(
        address vat_,
        address flapper_,
        address flopper_
    ) public {
        wards[msg.sender] = 1;
        vat = VatLike(vat_);
        flapper = FlapLike(flapper_);
        flopper = FlopLike(flopper_);
        vat.hope(flapper_);
        live = 1;
    }

    // --- Math ---
    function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x + y) >= x);
    }

    function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x - y) <= x);
    }

    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
        return x <= y ? x : y;
    }

    // --- Administration ---
    function file(bytes32 what, uint256 data) external {
        if (what == "wait") wait = data;
        else if (what == "bump") bump = data;
        else if (what == "sump") sump = data;
        else if (what == "dump") dump = data;
        else if (what == "hump") hump = data;
        else revert("Vow/file-unrecognized-param");
        emit File(what, data);
    }

    function file(bytes32 what, address data) external {
        if (what == "flapper") {
            vat.nope(address(flapper));
            flapper = FlapLike(data);
            vat.hope(data);
        } else if (what == "flopper") flopper = FlopLike(data);
        else revert("Vow/file-unrecognized-param");
        emit File(what, data);
    }

    // Push to debt-queue
    function fess(uint256 tab) external {
        sin[now] = add(sin[now], tab);
        Sin = add(Sin, tab);
        emit Fess(tab);
    }

    // Pop from debt-queue
    function flog(uint256 era) external {
        require(add(era, wait) <= now, "Vow/wait-not-finished");
        Sin = sub(Sin, sin[era]);
        sin[era] = 0;
        emit Flog(era);
    }

    // Debt settlement
    function heal(uint256 rad) external {
        require(rad <= vat.irdt(address(this)), "Vow/insufficient-surplus");
        require(
            rad <= sub(sub(vat.sin(address(this)), Sin), Ash),
            "Vow/insufficient-debt"
        );
        vat.heal(rad);
        emit Heal(rad);
    }

    function kiss(uint256 rad) external {
        require(rad <= Ash, "Vow/not-enough-ash");
        require(rad <= vat.irdt(address(this)), "Vow/insufficient-surplus");
        Ash = sub(Ash, rad);
        vat.heal(rad);

        emit Kiss(rad);
    }

    // Debt auction
    function flop() external returns (uint256 id) {
        require(
            sump <= sub(sub(vat.sin(address(this)), Sin), Ash),
            "Vow/insufficient-debt"
        );
        require(vat.irdt(address(this)) == 0, "Vow/surplus-not-zero");
        Ash = add(Ash, sump);
        id = flopper.kick(address(this), dump, sump);
        emit Flop(id);
    }

    // Surplus auction
    function flap() external returns (uint256 id) {
        require(
            vat.irdt(address(this)) >=
                add(add(vat.sin(address(this)), bump), hump),
            "Vow/insufficient-surplus"
        );
        require(
            sub(sub(vat.sin(address(this)), Sin), Ash) == 0,
            "Vow/debt-not-zero"
        );
        id = flapper.kick(bump, 0);
        emit Flap(id);
    }

    function cage() external {
        require(live == 1, "Vow/not-live");
        live = 0;
        Sin = 0;
        Ash = 0;
        flapper.cage(vat.irdt(address(flapper)));
        flopper.cage();
        vat.heal(min(vat.irdt(address(this)), vat.sin(address(this))));
        emit Cage();
    }
}
