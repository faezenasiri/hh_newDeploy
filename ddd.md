weth = new WETH();
ethJoin = new GemJoin(address(vat), "ETH", address(weth));
dssDeploy.deployCollateralFlip(
"ETH",
address(ethJoin),
address(pipETH)
);

        col = new DSToken("COL");
        colJoin = new GemJoin(address(vat), "COL", address(col));
        dssDeploy.deployCollateralFlip(
            "COL",
            address(colJoin),
            address(pipCOL)
        );

        col2 = new DSToken("COL2");
        col2Join = new GemJoin(address(vat), "COL2", address(col2));
        LinearDecrease calc = calcFab.newLinearDecrease(address(this));
        calc.file(bytes32("tau"), 1 hours);

        dssDeploy.deployCollateralClip(
            "COL2",
            address(col2Join),
            address(pipCOL2),
            address(calc)
        );

        // Set Params
        vat.file(bytes32("Line"), uint256(10000 * 10**45));
        vat.file(bytes32("COL"), bytes32("line"), uint256(10000 * 10**45));
        vat.file(bytes32("COL2"), bytes32("line"), uint256(10000 * 10**45));

        pipETH.poke(bytes32(uint256(300 * 10**18))); // Price 300 IRDT = 1 ETH (precision 18)
        pipCOL.poke(bytes32(uint256(45 * 10**18))); // Price 45 IRDT = 1 COL (precision 18)
        pipCOL2.poke(bytes32(uint256(30 * 10**18))); // Price 30 IRDT = 1 COL2 (precision 18)
        (ethFlip, , ) = dssDeploy.ilks("ETH");
        (colFlip, , ) = dssDeploy.ilks("COL");
        (, col2Clip, ) = dssDeploy.ilks("COL2");
        spotter.file("ETH", "mat", uint256(1500000000 ether)); // Liquidation ratio 150%
        spotter.file("COL", "mat", uint256(1100000000 ether)); // Liquidation ratio 110%
        spotter.file("COL2", "mat", uint256(1500000000 ether)); // Liquidation ratio 150%
        spotter.poke("ETH");
        spotter.poke("COL");
        spotter.poke("COL2");
        (, , uint256 spot, , ) = vat.ilks("ETH");
        //assertEq(spot, (300 * RAY * RAY) / 1500000000 ether);
        (, , spot, , ) = vat.ilks("COL");
        //assertEq(spot, (45 * RAY * RAY) / 1100000000 ether);
        (, , spot, , ) = vat.ilks("COL2");
        // assertEq(spot, (30 * RAY * RAY) / 1500000000 ether);









    function deployKeepAuth() public {
        dssDeploy.deployVat();
        dssDeploy.deployIRDT(5);
        dssDeploy.deployTaxation();
        dssDeploy.deployAuctions(
            address(0x386B1807a2454D02E3aD162af26f209a340f90f5)
        );
        dssDeploy.deployLiquidator();
        dssDeploy.deployEnd();
        dssDeploy.deployPause(
            0,
            address(0x386B1807a2454D02E3aD162af26f209a340f90f5)
        );
        dssDeploy.deployESM(
            address(0x386B1807a2454D02E3aD162af26f209a340f90f5),
            10
        );

        vat = dssDeploy.vat();
        jug = dssDeploy.jug();
        vow = dssDeploy.vow();
        cat = dssDeploy.cat();
        dog = dssDeploy.dog();
        flap = dssDeploy.flap();
        flop = dssDeploy.flop();
        irdt = dssDeploy.irdt();
        irdtJoin = dssDeploy.irdtJoin();
        spotter = dssDeploy.spotter();
        pot = dssDeploy.pot();
        cure = dssDeploy.cure();
        end = dssDeploy.end();
        esm = dssDeploy.esm();
        pause = dssDeploy.pause();


    }

\

    DSToken col;
    DSToken col2;
    Flipper colFlip;
    Clipper col2Clip;
