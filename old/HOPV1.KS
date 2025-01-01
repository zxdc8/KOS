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

set HDR to SHIP:PARTSDUBBED("header")[0].

LOCK THROTTLE TO 1.0.

PRINT "Counting down:".
FROM {local countdown is 5.} UNTIL countdown = 0 STEP {SET countdown to countdown - 1.} DO {
    PRINT "..." + countdown.
    WAIT 1. // pauses the script here for 1 second.
}

RAP1:ACTIVATE.
RAP2:ACTIVATE.
RAP3:ACTIVATE.

//Ascent Phase
PRINT "ASCENT PHASE...".

SAS ON.

UNTIL ALTITUDE > 100{
	
	}
	
PRINT "ROLL PROGRAM...".
SAS OFF.
UNTIL ALTITUDE >=500{
	LOCK STEERING TO HEADING(89.9,89.9,180).
}

PRINT "PITCHING...".

UNTIL APOAPSIS >=40000{
	LOCK STEERING TO HEADING(90,80,180).
}

//Coast to apogee
LOCK THROTTLE TO 0.0.
RAP1:shutdown.
RAP2:shutdown.
RAP3:shutdown.
LOCK STEERING TO ship:velocity:surface.
RCS ON.

PRINT "WAITING FOR APOGEE...".
UNTIL VERTICALSPEED < 50{	
	WAIT 0.01.
}

//Flip Horizontal
PRINT "BELLYFLOP...".
set FINLF_CTL to FINLF:getmodule("ModuleSEPControlSurface").
set FINRF_CTL to FINRF:getmodule("ModuleSEPControlSurface").
set FINLR_CTL to FINLR:getmodule("ModuleSEPControlSurface").
set FINRR_CTL to FINRR:getmodule("ModuleSEPControlSurface").

FINLF_CTL:SETFIELD("DEPLOY",1).
FINRF_CTL:SETFIELD("DEPLOY",1).
FINRR_CTL:SETFIELD("DEPLOY",1).
FINLR_CTL:SETFIELD("DEPLOY",1).
	
UNTIL ALTITUDE < 750{
	LOCK STEERING TO HEADING(270,000,000).
}	

//FLIP TIME
PRINT "FLIP...".
set HDR:resources[0]:enabled to 1.
set HDR:resources[1]:enabled to 1.
RAP1:ACTIVATE.
RAP2:ACTIVATE.
RAP3:ACTIVATE.	

//Define PID and Targets

LOCK VS to VERTICALSPEED.

SET Kp TO 0.3.
SET Ki TO 0.01.
SET Kd TO 0.01.
SET PIDVS TO PIDLOOP(Kp, Ki, Kd).

SET Khp TO 0.075.

SET PID:MINOUTPUT TO 0.05.
SET PID:MAXOUTPUT TO 1.

SET thrott TO 1.
LOCK THROTTLE TO thrott.

SET COMPLETE TO 0.


SET Kp to 0.075.
SET Ki to 0.01.
SET Kd to 0.01.

SET PIDVS to PIDLOOP(Kp, Ki, Kd).

local gravity is (constant():g*body:mass)/(body:radius^2).
local bounds_box is ship:bounds.
	
UNTIL COMPLETE  {
    SET thrott to PIDVS:UPDATE(TIME:SECONDS, VS).

    WAIT 0.001.
	SET TGTVS TO -(0.1 + bounds_box:BOTTOMALTRADAR/5).
	SET PIDVS:SETPOINT TO TGTVS.
	
	set desSteer to lookdirup(up:vector * gravity - Khp*vectorExclude(up:vector, ship:velocity:surface) ,ship:facing:topvector).
	LOCK STEERING TO DESSTEER.
	
	set act1 to RAP1:getmodule("ModuleSEPRaptor").
	set act2 to RAP2:getmodule("ModuleSEPRaptor").
	set act3 to RAP3:getmodule("ModuleSEPRaptor").

	
	IF ship:velocity:surface:mag <50{
		RAP1:shutdown.
		act1:setfield("actuate out",1).
	}
	IF ship:velocity:surface:mag <20{
		RAP2:shutdown.
		act2:setfield("actuate out",1).
		SET Khp to 0.5.
	}
	
	
	IF bounds_box:BOTTOMALTRADAR < 0.1{
		SET COMPLETE TO 1.
		SET thrott to 0.
		UNLOCK steering.
		}
}	