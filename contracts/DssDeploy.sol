pragma solidity >=0.5.12;

import {DSPause} from "./ds-pause/pause.sol";

import {Vat} from "./dss/vat.sol";
import {Jug} from "./dss/jug.sol";
import {Vow} from "./dss/vow.sol";
import {Cat} from "./dss/cat.sol";
import {Dog} from "./dss/dog.sol";
import {IRDTJoin} from "./dss/join.sol";
import {Flapper} from "./dss/flap.sol";
import {Flopper} from "./dss/flop.sol";
import {Flipper} from "./dss/flip.sol";
import {Clipper} from "./dss/clip.sol";
import {LinearDecrease, StairstepExponentialDecrease, ExponentialDecrease} from "./dss/abaci.sol";
import {IRDT} from "./dss/irdt.sol";
import {Cure} from "./dss/cure.sol";
import {End} from "./dss/end.sol";
import {ESM} from "./esm/ESM.sol";
import {Pot} from "./dss/pot.sol";
import {Spotter} from "./dss/spot.sol";

contract VatFab {
    function newVat(address owner) public returns (Vat vat) {
        vat = new Vat();
        vat.rely(owner);
    }
}

contract JugFab {
    function newJug(address owner, address vat) public returns (Jug jug) {
        jug = new Jug(vat);
        jug.rely(owner);
    }
}

contract VowFab {
    function newVow(
        address owner,
        address vat,
        address flap,
        address flop
    ) public returns (Vow vow) {
        vow = new Vow(vat, flap, flop);
        vow.rely(owner);
    }
}

contract CatFab {
    function newCat(address owner, address vat) public returns (Cat cat) {
        cat = new Cat(vat);
        cat.rely(owner);
    }
}

contract DogFab {
    function newDog(address owner, address vat) public returns (Dog dog) {
        dog = new Dog(vat);
        dog.rely(owner);
    }
}

contract IRDTFab {
    function newirdt(address owner, uint256 chainId)
        public
        returns (IRDT irdt)
    {
        irdt = new IRDT(chainId);
        irdt.rely(owner);
    }
}

contract IRDTJoinFab {
    function newIRDTJoin(address vat, address irdt)
        public
        returns (IRDTJoin irdtJoin)
    {
        irdtJoin = new IRDTJoin(vat, irdt);
    }
}

contract FlapFab {
    function newFlap(
        address owner,
        address vat,
        address gov
    ) public returns (Flapper flap) {
        flap = new Flapper(vat, gov);
        flap.rely(owner);
    }
}

contract FlopFab {
    function newFlop(
        address owner,
        address vat,
        address gov
    ) public returns (Flopper flop) {
        flop = new Flopper(vat, gov);
        flop.rely(owner);
    }
}

contract FlipFab {
    function newFlip(
        address owner,
        address vat,
        address cat,
        bytes32 ilk
    ) public returns (Flipper flip) {
        flip = new Flipper(vat, cat, ilk);
        flip.rely(owner);
    }
}

contract ClipFab {
    function newClip(
        address owner,
        address vat,
        address spotter,
        address dog,
        bytes32 ilk
    ) public returns (Clipper clip) {
        clip = new Clipper(vat, spotter, dog, ilk);
        clip.rely(owner);
    }
}

contract CalcFab {
    function newLinearDecrease(address owner)
        public
        returns (LinearDecrease calc)
    {
        calc = new LinearDecrease();
        calc.rely(owner);
    }

    function newStairstepExponentialDecrease(address owner)
        public
        returns (StairstepExponentialDecrease calc)
    {
        calc = new StairstepExponentialDecrease();
        calc.rely(owner);
    }

    function newExponentialDecrease(address owner)
        public
        returns (ExponentialDecrease calc)
    {
        calc = new ExponentialDecrease();
        calc.rely(owner);
    }
}

contract SpotFab {
    function newSpotter(address owner, address vat)
        public
        returns (Spotter spotter)
    {
        spotter = new Spotter(vat);
        spotter.rely(owner);
    }
}

contract PotFab {
    function newPot(address owner, address vat) public returns (Pot pot) {
        pot = new Pot(vat);
        pot.rely(owner);
    }
}

contract CureFab {
    function newCure(address owner) public returns (Cure cure) {
        cure = new Cure();
        cure.rely(owner);
    }
}

contract EndFab {
    function newEnd(address owner) public returns (End end) {
        end = new End();
        end.rely(owner);
    }
}

contract ESMFab {
    function newESM(
        address gov,
        address end,
        address proxy,
        uint256 min
    ) public returns (ESM esm) {
        esm = new ESM(gov, end, proxy, min);
    }
}

contract PauseFab {
    function newPause(
        uint256 delay,
        address owner,
        address authority
    ) public returns (DSPause pause) {
        pause = new DSPause(delay, owner, authority);
    }
}

contract DssDeploy {
    VatFab public vatFab;
    JugFab public jugFab;
    VowFab public vowFab;
    CatFab public catFab;
    DogFab public dogFab;
    IRDTFab public irdtFab;
    IRDTJoinFab public irdtJoinFab;
    FlapFab public flapFab;
    FlopFab public flopFab;
    FlipFab public flipFab;
    ClipFab public clipFab;
    CalcFab public calcFab;
    SpotFab public spotFab;
    PotFab public potFab;
    CureFab public cureFab;
    EndFab public endFab;
    ESMFab public esmFab;
    PauseFab public pauseFab;

    Vat public vat;
    Jug public jug;
    Vow public vow;
    Cat public cat;
    Dog public dog;
    IRDT public irdt;
    IRDTJoin public irdtJoin;
    Flapper public flap;
    Flopper public flop;
    Spotter public spotter;
    Pot public pot;
    Cure public cure;
    End public end;
    ESM public esm;
    DSPause public pause;

    mapping(bytes32 => Ilk) public ilks;

    uint8 public step = 0;

    uint256 constant ONE = 10**27;

    struct Ilk {
        Flipper flip;
        Clipper clip;
        address join;
    }

    function addFabsA(VatFab vatFab_, JugFab jugFab_) external {
        vatFab = vatFab_;
        jugFab = jugFab_;
    }

    function addFabsB(VowFab vowFab_, CatFab catFab_) external {
        vowFab = vowFab_;
        catFab = catFab_;
    }

    function addFabsC(
        DogFab dogFab_,
        IRDTFab irdtFab_,
        IRDTJoinFab irdtJoinFab_
    ) external {
        dogFab = dogFab_;
        irdtFab = irdtFab_;
        irdtJoinFab = irdtJoinFab_;
    }

    function addFabsD(
        FlapFab flapFab_,
        FlopFab flopFab_,
        FlipFab flipFab_
    ) external {
        flapFab = flapFab_;
        flopFab = flopFab_;
        flipFab = flipFab_;
    }

    function addFabsE(
        ClipFab clipFab_,
        CalcFab calcFab_,
        SpotFab spotFab_,
        PotFab potFab_
    ) external {
        //require(address(vatFab) == address(0), "Fabs 1 already saved");
        clipFab = clipFab_;
        calcFab = calcFab_;
        spotFab = spotFab_;
        potFab = potFab_;
    }

    function addFabsF(
        CureFab cureFab_,
        EndFab endFab_,
        ESMFab esmFab_,
        PauseFab pauseFab_
    ) external {
        // require(address(flapFab) == address(0), "Fabs 2 already saved");

        cureFab = cureFab_;
        endFab = endFab_;
        esmFab = esmFab_;
        pauseFab = pauseFab_;
    }

    function rad(uint256 wad) internal pure returns (uint256) {
        return wad * 10**27;
    }

    function deployVat() public {
        require(address(vatFab) != address(0), "Missing Fabs 1");
        require(address(flapFab) != address(0), "Missing Fabs 2");
        require(address(vat) == address(0), "VAT already deployed");
        vat = vatFab.newVat(address(this));
        spotter = spotFab.newSpotter(address(this), address(vat));

        // Internal auth
        vat.rely(address(spotter));
    }

    function deployIRDT(uint256 chainId) public {
        require(address(vat) != address(0), "Missing previous step");

        // Deploy
        irdt = irdtFab.newirdt(address(this), chainId);
        irdtJoin = irdtJoinFab.newIRDTJoin(address(vat), address(irdt));
        irdt.rely(address(irdtJoin));
    }

    function deployTaxation() public {
        require(address(vat) != address(0), "Missing previous step");

        // Deploy
        jug = jugFab.newJug(address(this), address(vat));
        pot = potFab.newPot(address(this), address(vat));

        // Internal auth
        vat.rely(address(jug));
        vat.rely(address(pot));
    }

    function deployAuctions(address gov) public {
        require(gov != address(0), "Missing GOV address");
        require(address(jug) != address(0), "Missing previous step");

        // Deploy
        flap = flapFab.newFlap(address(this), address(vat), gov);
        flop = flopFab.newFlop(address(this), address(vat), gov);
        vow = vowFab.newVow(
            address(this),
            address(vat),
            address(flap),
            address(flop)
        );

        // Internal references set up
        jug.file("vow", address(vow));
        pot.file("vow", address(vow));

        // Internal auth
        vat.rely(address(flop));
        flap.rely(address(vow));
        flop.rely(address(vow));
    }

    function deployLiquidator() public {
        require(address(vow) != address(0), "Missing previous step");

        // Deploy
        cat = catFab.newCat(address(this), address(vat));
        dog = dogFab.newDog(address(this), address(vat));

        // Internal references set up
        cat.file("vow", address(vow));
        dog.file("vow", address(vow));

        // Internal auth
        vat.rely(address(cat));
        vat.rely(address(dog));
        vow.rely(address(cat));
        vow.rely(address(dog));
    }

    function deployEnd() public {
        require(address(cat) != address(0), "Missing previous step");

        // Deploy
        cure = cureFab.newCure(address(this));
        end = endFab.newEnd(address(this));

        // Internal references set up
        end.file("vat", address(vat));
        end.file("cat", address(cat));
        end.file("dog", address(dog));
        end.file("vow", address(vow));
        end.file("pot", address(pot));
        end.file("spot", address(spotter));
        end.file("cure", address(cure));

        // Internal auth
        vat.rely(address(end));
        cat.rely(address(end));
        dog.rely(address(end));
        vow.rely(address(end));
        pot.rely(address(end));
        spotter.rely(address(end));
        cure.rely(address(end));
    }

    function deployPause(uint256 delay, address authority) public {
        require(address(irdt) != address(0), "Missing previous step");
        require(address(end) != address(0), "Missing previous step");

        pause = pauseFab.newPause(delay, msg.sender, authority);

        vat.rely(address(pause.proxy()));
        cat.rely(address(pause.proxy()));
        dog.rely(address(pause.proxy()));
        vow.rely(address(pause.proxy()));
        jug.rely(address(pause.proxy()));
        pot.rely(address(pause.proxy()));
        spotter.rely(address(pause.proxy()));
        flap.rely(address(pause.proxy()));
        flop.rely(address(pause.proxy()));
        cure.rely(address(pause.proxy()));
        end.rely(address(pause.proxy()));
    }

    function deployESM(address gov, uint256 min) public {
        require(address(pause) != address(0), "Missing previous step");

        // Deploy ESM
        esm = esmFab.newESM(gov, address(end), address(pause.proxy()), min);
        end.rely(address(esm));
        vat.rely(address(esm));
    }

    function deployCollateralFlip(
        bytes32 ilk,
        address join,
        address pip
    ) public {
        require(ilk != bytes32(""), "Missing ilk name");
        require(join != address(0), "Missing join address");
        require(pip != address(0), "Missing pip address");
        require(address(pause) != address(0), "Missing previous step");

        // Deploy
        ilks[ilk].flip = flipFab.newFlip(
            address(this),
            address(vat),
            address(cat),
            ilk
        );
        ilks[ilk].join = join;
        Spotter(spotter).file(ilk, "pip", address(pip)); // Set pip

        // Internal references set up
        cat.file(ilk, "flip", address(ilks[ilk].flip));
        vat.init(ilk);
        jug.init(ilk);

        // Internal auth
        vat.rely(join);
        cat.rely(address(ilks[ilk].flip));
        ilks[ilk].flip.rely(address(cat));
        ilks[ilk].flip.rely(address(end));
        ilks[ilk].flip.rely(address(esm));
        ilks[ilk].flip.rely(address(pause.proxy()));
    }

    function deployCollateralClip(
        bytes32 ilk,
        address join,
        address pip,
        address calc
    ) public {
        require(ilk != bytes32(""), "Missing ilk name");
        require(join != address(0), "Missing join address");
        require(pip != address(0), "Missing pip address");
        require(address(pause) != address(0), "Missing previous step");

        // Deploy
        ilks[ilk].clip = clipFab.newClip(
            address(this),
            address(vat),
            address(spotter),
            address(dog),
            ilk
        );
        ilks[ilk].join = join;
        Spotter(spotter).file(ilk, "pip", address(pip)); // Set pip

        // Internal references set up
        dog.file(ilk, "clip", address(ilks[ilk].clip));
        ilks[ilk].clip.file("vow", address(vow));

        // Use calc with safe default if not configured
        if (calc == address(0)) {
            calc = address(calcFab.newLinearDecrease(address(this)));
            LinearDecrease(calc).file(bytes32("tau"), 1 hours);
        }
        ilks[ilk].clip.file("calc", calc);
        vat.init(ilk);
        jug.init(ilk);

        // Internal auth
        vat.rely(join);
        vat.rely(address(ilks[ilk].clip));
        dog.rely(address(ilks[ilk].clip));
        ilks[ilk].clip.rely(address(dog));
        ilks[ilk].clip.rely(address(end));
        ilks[ilk].clip.rely(address(esm));
        ilks[ilk].clip.rely(address(pause.proxy()));
    }
}
