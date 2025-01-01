run "./lib/lib_control.ks".
run "./lib/lib_navutils.ks".
run "./lib/lib_sysutils.ks".
run "./lib/lib_navball.ks".
run "./starship/mnvr.ks".
run "./starship/programs.ks".
run "./lib/lib_geodec.ks".

set RAP1 to SHIP:PARTSDUBBED("RAP1")[0].
set RAP2 to SHIP:PARTSDUBBED("RAP2")[0].
set RAP3 to SHIP:PARTSDUBBED("RAP3")[0].
set RAPV1 to SHIP:PARTSDUBBED("RAPV1")[0].
set RAPV2 to SHIP:PARTSDUBBED("RAPV2")[0].
set RAPV3 to SHIP:PARTSDUBBED("RAPV3")[0].
set HDR to SHIP:PARTSDUBBED("header")[0].
set DMP to SHIP:PARTSDUBBED("dump")[0].

set act1 to RAP1:getmodule("ModuleSEPRaptor").
set act2 to RAP2:getmodule("ModuleSEPRaptor").
set act3 to RAP3:getmodule("ModuleSEPRaptor").

set FINLF to SHIP:PARTSDUBBED("FINLF")[0].
set FINRF to SHIP:PARTSDUBBED("FINRF")[0].
set FINLR to SHIP:PARTSDUBBED("FINLR")[0].
set FINRR to SHIP:PARTSDUBBED("FINRR")[0].
set GF1 to ship:partsdubbed("gf1")[0].
set GF2 to ship:partsdubbed("gf2")[0].
set GF3 to ship:partsdubbed("gf3")[0].
set GF4 to ship:partsdubbed("gf4")[0].
set cluster to ship:partsdubbed("cluster")[0].
set olm to ship:partsnamed(SLE.SS.OLM)[0].


ON AG1 {
	set runMode to runMode - 1.
	set updateSettings to true.
}
ON AG2 {
	set runMode TO runMode + 1.
	set updateSettings to true.
}

set runmode to 9.

until false{
    if runMode = 9{
        print "------------------".
        print "STARSHIP AUTOPILOT".
        print "------------------".
        print "Select Program".
        print "1) Simple Hop".
        print "2) bellyFlopToLand".
        print "3) tgtLand".
        print "4) primaryAscent".

        set ch to terminal:input:getchar().

        set runMode to ch.
    }

    if runMode = 1{
        simpleHop().

        set runMode to 9.
    
    }

    if runMode = 2{
        bellyFlopToLand().

        set runMode to 9.
    
    }

    if runMode = 3{
        tgtLand().

        set runMode to 9.
    
    }

    if runMode = 4{
        primaryAscent().

        set runMode to 9.
    
    }

    else{
        print "------------------".
        print "!!!INVALID MODE!!!".
        print "------------------".
        wait 0.1.
        set runMode to 9.
    }













}


