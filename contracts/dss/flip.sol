// SPDX-License-Identifier: AGPL-3.0-or-later

/// flip.sol -- Collateral auction

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

pragma solidity >=0.5.12;

// FIXME: This contract was altered compared to the production version.
// It doesn't use LibNote anymore.
// New deployments of this contract will need to include custom events (TO DO).

interface VatLike {
    function move(
        address,
        address,
        uint256
    ) external;

    function flux(
        bytes32,
        address,
        address,
        uint256
    ) external;
}

interface CatLike {
    function claw(uint256) external;
}

/*
   This thing lets you flip some gems for a given amount of irdt.
   Once the given amount of irdt is raised, gems are forgone instead.

 - `lot` gems in return for bid
 - `tab` total irdt wanted
 - `bid` irdt paid
 - `gal` receives irdt income
 - `usr` receives gem forgone
 - `ttl` single bid lifetime
 - `beg` minimum bid increase
 - `end` max auction duration
*/

contract Flipper {
    // ---  ---
    mapping(address => uint256) public wards;

    function rely(address usr) external {
        wards[usr] = 1;
        emit Rely(usr);
    }

    function deny(address usr) external {
        wards[usr] = 0;
        emit Deny(usr);
    }

    // --- Data ---
    struct Bid {
        uint256 bid; // irdt paid                 [rad]
        uint256 lot; // gems in return for bid   [wad]
        address guy; // high bidder
        uint48 tic; // bid expiry time          [unix epoch time]
        uint48 end; // auction expiry time      [unix epoch time]
        address usr;
        address gal;
        uint256 tab; // total irdt wanted         [rad]
    }

    mapping(uint256 => Bid) public bids;

    VatLike public vat; // CDP Engine
    bytes32 public ilk; // collateral type

    uint256 constant ONE = 1.00E18;
    uint256 public beg = 1.05E18; // 5% minimum bid increase
    uint48 public ttl = 3 hours; // 3 hours bid duration         [seconds]
    uint48 public tau = 2 days; // 2 days total auction length  [seconds]
    uint256 public kicks = 0;
    CatLike public cat; // cat liquidation module

    // --- Events ---
    event Kick(
        uint256 id,
        uint256 lot,
        uint256 bid,
        uint256 tab,
        address indexed usr,
        address indexed gal
    );

    event Kick(uint256 id, uint256 lot, uint256 bid, address indexed gal);

    event Rely(address indexed usr);
    event Deny(address indexed usr);
    event File(bytes32 indexed what, uint256 data);

    event File(bytes32 indexed what, address indexed data);

    event Tick(uint256 indexed id);
    event Tend(uint256 indexed id, uint256 lot, uint256 bid);

    event Dent(uint256 indexed id, uint256 lot, uint256 bid);

    event Deal(uint256 indexed id);

    event Yank(uint256 indexed id);

    // --- Init ---
    constructor(
        address vat_,
        address cat_,
        bytes32 ilk_
    ) public {
        vat = VatLike(vat_);
        cat = CatLike(cat_);
        ilk = ilk_;
        wards[msg.sender] = 1;
    }

    // --- Math ---
    function add(uint48 x, uint48 y) internal pure returns (uint48 z) {
        require((z = x + y) >= x);
    }

    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require(y == 0 || (z = x * y) / y == x);
    }

    // --- Admin ---
    function file(bytes32 what, uint256 data) external {
        if (what == "beg") beg = data;
        else if (what == "ttl") ttl = uint48(data);
        else if (what == "tau") tau = uint48(data);
        else revert("Flipper/file-unrecognized-param");
        emit File(what, data);
    }

    function file(bytes32 what, address data) external {
        if (what == "cat") cat = CatLike(data);
        else revert("Flipper/file-unrecognized-param");
        emit File(what, data);
    }

    // --- Auction ---
    function kick(
        address usr,
        address gal,
        uint256 tab,
        uint256 lot,
        uint256 bid
    ) public returns (uint256 id) {
        require(kicks < uint256(-1), "Flipper/overflow");
        id = ++kicks;

        bids[id].bid = bid;
        bids[id].lot = lot;
        bids[id].guy = msg.sender; // configurable??
        bids[id].end = add(uint48(now), tau);
        bids[id].usr = usr;
        bids[id].gal = gal;
        bids[id].tab = tab;

        vat.flux(ilk, msg.sender, address(this), lot);

        emit Kick(id, lot, bid, tab, usr, gal);
    }

    function tick(uint256 id) external {
        require(bids[id].end < now, "Flipper/not-finished");
        require(bids[id].tic == 0, "Flipper/bid-already-placed");
        bids[id].end = add(uint48(now), tau);
        emit Tick(id);
    }

    function tend(
        uint256 id,
        uint256 lot,
        uint256 bid
    ) external {
        require(bids[id].guy != address(0), "Flipper/guy-not-set");
        require(
            bids[id].tic > now || bids[id].tic == 0,
            "Flipper/already-finished-tic"
        );
        require(bids[id].end > now, "Flipper/already-finished-end");

        require(lot == bids[id].lot, "Flipper/lot-not-matching");
        require(bid <= bids[id].tab, "Flipper/higher-than-tab");
        require(bid > bids[id].bid, "Flipper/bid-not-higher");
        require(
            mul(bid, ONE) >= mul(beg, bids[id].bid) || bid == bids[id].tab,
            "Flipper/insufficient-increase"
        );

        if (msg.sender != bids[id].guy) {
            vat.move(msg.sender, bids[id].guy, bids[id].bid);
            bids[id].guy = msg.sender;
        }
        vat.move(msg.sender, bids[id].gal, bid - bids[id].bid);

        bids[id].bid = bid;
        bids[id].tic = add(uint48(now), ttl);
        emit Tend(id, lot, bid);
    }

    function dent(
        uint256 id,
        uint256 lot,
        uint256 bid
    ) external {
        require(bids[id].guy != address(0), "Flipper/guy-not-set");
        require(
            bids[id].tic > now || bids[id].tic == 0,
            "Flipper/already-finished-tic"
        );
        require(bids[id].end > now, "Flipper/already-finished-end");

        require(bid == bids[id].bid, "Flipper/not-matching-bid");
        require(bid == bids[id].tab, "Flipper/tend-not-finished");
        require(lot < bids[id].lot, "Flipper/lot-not-lower");
        require(
            mul(beg, lot) <= mul(bids[id].lot, ONE),
            "Flipper/insufficient-decrease"
        );

        if (msg.sender != bids[id].guy) {
            vat.move(msg.sender, bids[id].guy, bid);
            bids[id].guy = msg.sender;
        }
        vat.flux(ilk, address(this), bids[id].usr, bids[id].lot - lot);

        bids[id].lot = lot;
        bids[id].tic = add(uint48(now), ttl);
        emit Dent(id, lot, bid);
    }

    function deal(uint256 id) external {
        require(
            bids[id].tic != 0 && (bids[id].tic < now || bids[id].end < now),
            "Flipper/not-finished"
        );
        cat.claw(bids[id].tab);
        vat.flux(ilk, address(this), bids[id].guy, bids[id].lot);
        delete bids[id];
    }

    function yank(uint256 id) external {
        require(bids[id].guy != address(0), "Flipper/guy-not-set");
        require(bids[id].bid < bids[id].tab, "Flipper/already-dent-phase");
        cat.claw(bids[id].tab);
        vat.flux(ilk, address(this), msg.sender, bids[id].lot);
        vat.move(msg.sender, bids[id].guy, bids[id].bid);
        delete bids[id];
        emit Yank(id);
    }
}
