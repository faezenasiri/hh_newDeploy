pragma solidity >=0.5.12;

import "./DssDeploy.sol";

interface dssDeployLike {
    function addFabsC(
        DogFab,
        IRDTFab,
        IRDTJoinFab
    ) external;

    function addFabsA(VatFab, JugFab) external;

    function addFabsB(VowFab, CatFab) external;

    function addFabsD(
        FlapFab,
        FlopFab,
        FlipFab
    ) external;

    function addFabsE(
        ClipFab,
        CalcFab,
        SpotFab,
        PotFab
    ) external;

    function addFabsF(
        CureFab,
        EndFab,
        ESMFab,
        PauseFab
    ) external;
}

contract DssDeployBaseC {
    DogFab dogFab;
    IRDTFab irdtFab;
    IRDTJoinFab irdtJoinFab;

    function setUp(address dssdeploy) public {
        dogFab = new DogFab();
        irdtFab = new IRDTFab();
        irdtJoinFab = new IRDTJoinFab();

        dssDeployLike(dssdeploy).addFabsC(dogFab, irdtFab, irdtJoinFab);
    }
}

contract DssDeployBaseA {
    VatFab vatFab;
    JugFab jugFab;

    function setUp(address dssdeploy) public {
        vatFab = new VatFab();
        jugFab = new JugFab();

        dssDeployLike(dssdeploy).addFabsA(vatFab, jugFab);
    }
}

contract DssDeployBaseB {
    VowFab vowFab;
    CatFab catFab;

    function setUp(address dssdeploy) public {
        vowFab = new VowFab();
        catFab = new CatFab();

        dssDeployLike(dssdeploy).addFabsB(vowFab, catFab);
    }
}

contract DssDeployBaseE {
    ClipFab clipFab;
    CalcFab calcFab;
    SpotFab spotFab;
    PotFab potFab;

    function setUp(address dssdeploy) public {
        clipFab = new ClipFab();
        calcFab = new CalcFab();
        spotFab = new SpotFab();
        potFab = new PotFab();

        dssDeployLike(dssdeploy).addFabsE(clipFab, calcFab, spotFab, potFab);
    }
}

contract DssDeployBaseD {
    FlapFab flapFab;
    FlopFab flopFab;
    FlipFab flipFab;

    function setUp(address dssdeploy) public {
        flapFab = new FlapFab();
        flopFab = new FlopFab();
        flipFab = new FlipFab();

        dssDeployLike(dssdeploy).addFabsD(flapFab, flopFab, flipFab);
    }
}

contract DssDeployBaseF {
    CureFab cureFab;
    EndFab endFab;
    ESMFab esmFab;
    PauseFab pauseFab;

    function setUp(address dssdeploy) public {
        cureFab = new CureFab();
        endFab = new EndFab();
        esmFab = new ESMFab();
        pauseFab = new PauseFab();

        dssDeployLike(dssdeploy).addFabsF(cureFab, endFab, esmFab, pauseFab);
    }
}
