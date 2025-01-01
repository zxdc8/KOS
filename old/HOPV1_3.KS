//setup ship
set RAP1 to SHIP:PARTSDUBBED("RAP1")[0].
set RAP2 to SHIP:PARTSDUBBED("RAP2")[0].
set RAP3 to SHIP:PARTSDUBBED("RAP3")[0].
set RAPV1 to SHIP:PARTSDUBBED("RAPV1")[0].
set RAPV2 to SHIP:PARTSDUBBED("RAPV2")[0].
set RAPV3 to SHIP:PARTSDUBBED("RAPV3")[0].

set FINLF to SHIP:PARTSDUBBED("FINLF")[0].
set FINRF to SHIP:PARTSDUBBED("FINRF")[0].
set FINLR to SHIP:PARTSDUBBED("FINLR")[0].
set FINRR to SHIP:PARTSDUBBED("FINRR")[0].


//Flip Horizontal
set FINLF_CTL to FINLF:getmodule("ModuleSEPControlSurface").
set FINRF_CTL to FINRF:getmodule("ModuleSEPControlSurface").
set FINLR_CTL to FINLR:getmodule("ModuleSEPControlSurface").
set FINRR_CTL to FINRR:getmodule("ModuleSEPControlSurface").

FINLF_CTL:SETFIELD("DEPLOY",1).
FINRF_CTL:SETFIELD("DEPLOY",1).
FINRR_CTL:SETFIELD("DEPLOY",1).
FINLR_CTL:SETFIELD("DEPLOY",1).
	
UNTIL ALTITUDE < 1000{
	LOCK STEERING TO HEADING(180,000,000).
}	

//FLIP TIME
//LOCK THROTTLE TO 1.0.
RAP1:ACTIVATE.
RAP2:ACTIVATE.
RAP3:ACTIVATE.	

//Define PID and Targets

LOCK VS to VERTICALSPEED.

SET Kp TO 0.3.
SET Ki TO 0.01.
SET Kd TO 0.01.
SET PID TO PIDLOOP(Kp, Ki, Kd).

SET PID:MINOUTPUT TO 0.05.
SET PID:MAXOUTPUT TO 1.

LOCK TGTVS to 0.

//(0.25+ALTITUDE/10).

SET PID:SETPOINT TO 10.

SET thrott TO 0.5.
LOCK THROTTLE TO thrott.

SET COMPLETE TO 0.

UNTIL COMPLETE  {
    SET thrott to PID:UPDATE(TIME:SECONDS, VS).
    // pid:update() is given the input time and input and returns the output. gforce is the input.
    WAIT 0.001.
	PRINT THROTT.
	SET TGTVS TO -(0.5 + ALTITUDE/20).
	SET PID:SETPOINT TO TGTVS.
	
	local gravity is (constant():g*body:mass)/(body:radius^2).
	set desSteer to lookdirup(up:vector * gravity - 0.1*vectorExclude(up:vector, ship:velocity:surface) ,ship:facing:topvector).
	LOCK STEERING TO DESSTEER.
	IF NOT SHIP:STATUS = "FLYING"{
		SET COMPLETE TO 1.
		SET thrott to 0.
		}
}	