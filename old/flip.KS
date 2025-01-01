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

	
UNTIL ALTITUDE < 850{
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

SET PIDVS:MINOUTPUT TO 0.05.
SET PIDVS:MAXOUTPUT TO 1.

SET thrott TO 1.
LOCK THROTTLE TO thrott.

SET COMPLETE TO 0.


SET Kph to 0.015.
SET Kih to 0.000.
SET Kdh to 0.000.

SET PIDHS to PIDLOOP(Kph, Kih, Kdh).
//SET PIDHS:MINOUTPUT TO 0.0.
//SET PIDHS:MAXOUTPUT TO 0.3.
//SET PIDHS:SETPOINT TO 0.

local gravity is (constant():g*body:mass)/(body:radius^2).
local bounds_box is ship:bounds.
	
UNTIL COMPLETE  {
    SET thrott to PIDVS:UPDATE(TIME:SECONDS, VS).

    WAIT 0.001.
	SET TGTVS TO -(0.5 + bounds_box:BOTTOMALTRADAR/7.5).
	SET PIDVS:SETPOINT TO TGTVS.
	
	SET hComp to -vectorExclude(up:vector, ship:velocity:surface).
	SET hSteer to PIDHS:UPDATE(TIME:SECONDS, hComp:mag).
	PRINT hSteer.	
	PRINT hComp:mag.
	
	set desSteer to lookdirup(up:vector * gravity - hSteer*hComp:NORMALIZED ,ship:facing:topvector).
	LOCK STEERING TO DESSTEER.
	
	
	SET anArrow TO VECDRAWARGS(
      V(0,0,0),
      desSteer:vector,
      RGB(1,0,0),
      "See the arrow?",
      1,
      TRUE,
      0.2,
      TRUE,
      TRUE
    ).
	
	set act1 to RAP1:getmodule("ModuleSEPRaptor").
	set act2 to RAP2:getmodule("ModuleSEPRaptor").
	set act3 to RAP3:getmodule("ModuleSEPRaptor").

	
	WHEN ship:velocity:surface:mag <50 THEN{
		RAP1:shutdown.
		act1:setfield("actuate out",1).
		SET PIDHS:Kp to 0.1.
		SET PIDHS:Kd to 0.05.
	}
	WHEN ship:velocity:surface:mag <20 THEN{
		RAP2:shutdown.
		act2:setfield("actuate out",1).
		SET PIDHS:Kp to 0.2.
		SET PIDHS:Kd to 0.1.
	}
	WHEN ship:velocity:surface:mag <5 THEN{
		SET PIDHS:Kp to 0.4.
	}
	
	
	WHEN bounds_box:BOTTOMALTRADAR < 0.1 THEN{
		SET COMPLETE TO 1.
		SET thrott to 0.
		UNLOCK steering.
		}
}	