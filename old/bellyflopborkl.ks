run control.ks.
run utils.ks.
run lib_navball.ks.


set RAP1 to SHIP:PARTSDUBBED("RAP1")[0].
set RAP2 to SHIP:PARTSDUBBED("RAP2")[0].
set RAP3 to SHIP:PARTSDUBBED("RAP3")[0].
set RAPV1 to SHIP:PARTSDUBBED("RAPV1")[0].
set RAPV2 to SHIP:PARTSDUBBED("RAPV2")[0].
set RAPV3 to SHIP:PARTSDUBBED("RAPV3")[0].

set act1 to RAP1:getmodule("ModuleSEPRaptor").
set act2 to RAP2:getmodule("ModuleSEPRaptor").
set act3 to RAP3:getmodule("ModuleSEPRaptor").

set FINLF to SHIP:PARTSDUBBED("FINLF")[0].
set FINRF to SHIP:PARTSDUBBED("FINRF")[0].
set FINLR to SHIP:PARTSDUBBED("FINLR")[0].
set FINRR to SHIP:PARTSDUBBED("FINRR")[0].

set HDR to SHIP:PARTSDUBBED("header")[0].

set FINLF_CTL to FINLF:getmodule("ModuleSEPControlSurface").
set FINRF_CTL to FINRF:getmodule("ModuleSEPControlSurface").
set FINLR_CTL to FINLR:getmodule("ModuleSEPControlSurface").
set FINRR_CTL to FINRR:getmodule("ModuleSEPControlSurface").

FINLF_CTL:SETFIELD("DEPLOY",1).
FINRF_CTL:SETFIELD("DEPLOY",1).
FINRR_CTL:SETFIELD("DEPLOY",1).
FINLR_CTL:SETFIELD("DEPLOY",1).

LOCK STEERING TO ADDONS:TR:PLANNEDVECTOR.

LOCAL done IS FALSE.
LOCAL drawsVector IS VECDRAW(SHIP:POSITION,ADDONS:TR:PLANNEDVECTOR * 10,RED,"Planned Vector",1,TRUE,1).
ON AG1 { SET done TO TRUE. }
UNTIL done {
  SET drawsVector:VEC TO ADDONS:TR:PLANNEDVECTOR * 10.
  WAIT 0.
}