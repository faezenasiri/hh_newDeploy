// SPDX-License-Identifier: AGPL-3.0-or-later

/// flap.sol -- Surplus auction

// Copyright (C) 2018 Rain <rainbreak@riseup.net>
// Copyright (C) 2022 irdt Foundation
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

interface VatLike {
    function move(
        address,
        address,
        uint256
    ) external;
}

interface GemLike {
    function move(
        address,
        address,
        uint256
    ) external;

    function burn(address, uint256) external;
}

/*
   This thing lets you sell some irdt in return for gems.

 - `lot` irdt in return for bid
 - `bid` gems paid
 - `ttl` single bid lifetime
 - `beg` minimum bid increase
 - `end` max auction duration
*/

contract Flapper {
    // --- Auth ---
    mapping(address => uint256) public wards;

    function rely(address usr) external {
        wards[usr] = 1;
    }

    function deny(address usr) external {
        wards[usr] = 0;
    }

    // --- Data ---
    struct Bid {
        uint256 bid; // gems paid               [wad]
        uint256 lot; // irdt in return for bid   [rad]
        address guy; // high bidder
        uint48 tic; // bid expiry time         [unix epoch time]
        uint48 end; // auction expiry time     [unix epoch time]
    }

    mapping(uint256 => Bid) public bids;

    VatLike public vat; // CDP Engine
    GemLike public gem;

    uint256 constant ONE = 1.00E18;
    uint256 public beg = 1.05E18; // 5% minimum bid increase
    uint48 public ttl = 3 hours; // 3 hours bid duration         [seconds]
    uint48 public tau = 2 days; // 2 days total auction length  [seconds]
    uint256 public kicks = 0;
    uint256 public live; // Active Flag
    uint256 public lid; // max irdt to be in auction at one time  [rad]
    uint256 public fill; // current irdt in auction                [rad]

    // --- Events ---

    event Kick(uint256 id, uint256 lot, uint256 bid);
    event Rely(address indexed usr);
    event Deny(address indexed usr);
    event File(bytes32 indexed what, uint256 data);
    event Tick(uint256 indexed id);

    event Tend(uint256 indexed id, uint256 lot, uint256 bid);

    event Deal(uint256 indexed id);

    event Cage();
    event Yank(uint256 indexed id);

    // --- Init ---
    constructor(address vat_, address gem_) public {
        wards[msg.sender] = 1;
        vat = VatLike(vat_);
        gem = GemLike(gem_);
        live = 1;
    }

    // --- Math ---
    function add(uint48 x, uint48 y) internal pure returns (uint48 z) {
        require((z = x + y) >= x);
    }

    function add256(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x + y) >= x);
    }

    function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x - y) <= x);
    }

    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require(y == 0 || (z = x * y) / y == x);
    }

    // --- Admin ---
    function file(bytes32 what, uint256 data) external {
        if (what == "beg") beg = data;
        else if (what == "ttl") ttl = uint48(data);
        else if (what == "tau") tau = uint48(data);
        else if (what == "lid") lid = data;
        else revert("Flapper/file-unrecognized-param");
        emit File(what, data);
    }

    // --- Auction ---
    function kick(uint256 lot, uint256 bid) external returns (uint256 id) {
        require(live == 1, "Flapper/not-live");
        require(kicks < uint256(-1), "Flapper/overflow");
        fill = add256(fill, lot);
        require(fill <= lid, "Flapper/over-lid");
        id = ++kicks;

        bids[id].bid = bid;
        bids[id].lot = lot;
        bids[id].guy = msg.sender; // configurable??
        bids[id].end = add(uint48(now), tau);

        vat.move(msg.sender, address(this), lot);

        emit Kick(id, lot, bid);
    }

    function tick(uint256 id) external {
        require(bids[id].end < now, "Flapper/not-finished");
        require(bids[id].tic == 0, "Flapper/bid-already-placed");
        bids[id].end = add(uint48(now), tau);
        emit Tick(id);
    }

    function tend(
        uint256 id,
        uint256 lot,
        uint256 bid
    ) external {
        require(live == 1, "Flapper/not-live");
        require(bids[id].guy != address(0), "Flapper/guy-not-set");
        require(
            bids[id].tic > now || bids[id].tic == 0,
            "Flapper/already-finished-tic"
        );
        require(bids[id].end > now, "Flapper/already-finished-end");

        require(lot == bids[id].lot, "Flapper/lot-not-matching");
        require(bid > bids[id].bid, "Flapper/bid-not-higher");
        require(
            mul(bid, ONE) >= mul(beg, bids[id].bid),
            "Flapper/insufficient-increase"
        );

        if (msg.sender != bids[id].guy) {
            gem.move(msg.sender, bids[id].guy, bids[id].bid);
            bids[id].guy = msg.sender;
        }
        gem.move(msg.sender, address(this), bid - bids[id].bid);

        bids[id].bid = bid;
        bids[id].tic = add(uint48(now), ttl);
        emit Tend(id, lot, bid);
    }

    function deal(uint256 id) external {
        require(live == 1, "Flapper/not-live");
        require(
            bids[id].tic != 0 && (bids[id].tic < now || bids[id].end < now),
            "Flapper/not-finished"
        );
        uint256 lot = bids[id].lot;
        vat.move(address(this), bids[id].guy, lot);
        gem.burn(address(this), bids[id].bid);
        delete bids[id];
        fill = sub(fill, lot);
        emit Deal(id);
    }

    function cage(uint256 rad) external {
        live = 0;
        vat.move(address(this), msg.sender, rad);
        emit Cage();
    }

    function yank(uint256 id) external {
        require(live == 0, "Flapper/still-live");
        require(bids[id].guy != address(0), "Flapper/guy-not-set");
        gem.move(address(this), bids[id].guy, bids[id].bid);
        delete bids[id];
        emit Yank(id);
    }
}
