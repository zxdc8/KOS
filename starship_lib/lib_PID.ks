//setup ship
set RAP1 to SHIP:PARTSDUBBED("RAP1")[0].
set RAP2 to SHIP:PARTSDUBBED("RAP2")[0].
set RAP3 to SHIP:PARTSDUBBED("RAP3")[0].
set RAPV1 to SHIP:PARTSDUBBED("RAPV1")[0].
set RAPV2 to SHIP:PARTSDUBBED("RAPV2")[0].
set RAPV3 to SHIP:PARTSDUBBED("RAPV3")[0].


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