
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

set FINLF_CTL to FINLF:getmodule("ModuleSEPControlSurface").
set FINRF_CTL to FINRF:getmodule("ModuleSEPControlSurface").
set FINLR_CTL to FINLR:getmodule("ModuleSEPControlSurface").
set FINRR_CTL to FINRR:getmodule("ModuleSEPControlSurface").

FINLF_CTL:SETFIELD("DEPLOY",1).
FINRF_CTL:SETFIELD("DEPLOY",1).
FINRR_CTL:SETFIELD("DEPLOY",1).
FINLR_CTL:SETFIELD("DEPLOY",1).

set HDR to SHIP:PARTSDUBBED("header")[0].
set steer to heading(0,0,0).
lock steering to steer.

run control.ks.
run utils.ks.
run lib_navball.ks.

//set vxPID to pidLoop(0.01,0,0).
//set vyPID to pidLoop(10000,0,0).
//set vxPID:maxoutput to 50.
//set vyPID:minoutput to -50.
//set vxPID:maxoutput to 50.
//set vyPID:minoutput to -50.

set slopePID to pidLoop(0.125,0.000,0.01).
set slopePID:minoutput to -75.
set slopePID:maxoutput to 75.
set pitchAngPID to pidLoop(2,0.1,0.1).
set rollAngPID to pidLoop(1,0,0).
set pitchAngPID:minoutput to -30.
set pitchAngPID:maxoutput to 30.

set backuprollcontrolanglerange to steeringManager:rollcontrolanglerange.
set backupmaxstoppingtime to steeringManager:maxstoppingtime.
//SET STEERINGMANAGER:ROLLPID:kp TO 2*STEERINGMANAGER:ROLLPID:kp.
set steeringManager:rollcontrolanglerange to 60.
set steeringManager:maxstoppingtime to 0.5.

//28°32'56''N
//80°39'21''W
set tgtCoords to LATLNG(28.5490753849656, -80.6559313087451).

until altitude<900{

    set landingTgt to tgtCoords.

    set tgtDist to geoDistance(landingTgt, ship:geoposition).
    set tgtBrg to landingTgt:heading.

    set dLat to landingTgt:lat - ship:geoposition:lat.
    set dLong to landingTgt:lng - ship:geoposition:lng.

    set vLat to vdot(ship:velocity:surface, ship:north:forevector).
    set vLong to vdot(ship:velocity:surface, ship:north:starvector).

    set shipHdg to compass_for().
    set shipPit to pitch_for().
    set shipRoll to roll_for().

    set rotatedLongLat to rotate_2D_vec(dLong,dLat, shipHdg).
    set rotatedvLongLat to rotate_2D_vec(vLong,vLat, shipHdg).


    //set desiredVx to vxPID:UPDATE(TIME:seconds, rotatedLongLat[0]).
    //set desiredVy to vyPID:UPDATE(TIME:seconds, rotatedLongLat[1]).

    //Define approach path based on a steep glideslope
    set desiredDist to altitude/tan(80).

    //set desiredVx to tgtDist/20.
    
    set slopePID:setpoint to desiredDist.
    set desiredVx to -slopePID:update(time:seconds, tgtDist).

    //if desiredVx >50{
    //    set desiredVx to 50.
    //}
    //if desiredVx <-50{
    //    set desiredVx to -50.
    //}

    set pitchAngPID:setpoint to desiredVx.
    set rollAngPID:setpoint to 0.

    set groundspeedvec to ship:facing:inverse * ship:velocity:surface.
    set foreaftvel to groundspeedvec:z.

    set desiredPitchAngle to pitchAngPID:UPDATE(TIME:seconds, foreaftvel).
    set desiredRollAngle to  0.//rollAngPID:UPDATE(TIME:seconds, rotatedvLongLat[1]).

    print "Distance:"  + tgtDist.
    print "SlopeDist:" + desiredDist.
    print "DistError:" + (tgtDist-desiredDist).
    print "GS:"        + foreaftvel.
    print "DesiredGS:" + desiredVx.
    print "Desired Pitch:" + desiredPitchAngle.

    set steer to heading(tgtBrg, -desiredPitchAngle,0).

}

set steeringManager:rollcontrolanglerange to backuprollcontrolanglerange.
set steeringManager:maxstoppingtime to backupmaxstoppingtime.
//FLIP TIME
PRINT "FLIP...".
set HDR:resources[0]:enabled to 1.
set HDR:resources[1]:enabled to 1.
RAP1:ACTIVATE.
RAP2:ACTIVATE.
RAP3:ACTIVATE.	
RAPV1:shutdown.
RAPV2:shutdown.
RAPV3:shutdown.	

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

set desSteer to UP.

LOCK STEERING TO desSteer.

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

    WAIT 0.01.
	SET TGTVS TO -(0.5 + bounds_box:BOTTOMALTRADAR/5).
	SET PIDVS:SETPOINT TO TGTVS.
	
	SET hComp to -vectorExclude(up:vector, ship:velocity:surface).
	SET hSteer to PIDHS:UPDATE(TIME:SECONDS, hComp:mag).
	PRINT hSteer.	
	PRINT hComp:mag.
	
	set desSteer to lookdirup(up:vector * gravity - hSteer*hComp:NORMALIZED ,ship:facing:topvector).
	
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



//set pitchAngPID to pidLoop(0.1,0.00,0.00).
//set rollAngPID to pidLoop(0.2,0.00,0.00).
//set yawAngPID to pidLoop(0.1,0.00,0.00).
//
//set pitchAngPID:setpoint to desiredPitchAngle.
//set rollAngPID:setpoint to desiredRollAngle.
//set yawAngPID:setpoint to 90.
//

//print desiredPitchAngle.

//Control Torque with stick positions - provide a new value for torque wrt position error.
//SET controlStick to SHIP:CONTROL.
//set controlStick:pitch to pitchAngPID:update(TIME:seconds, shipPit).
//set controlStick:roll to rollAngPID:update(TIME:seconds, shipRoll). 
//set controlStick:yaw to yawAngPID:update(TIME:seconds, shipHdg). 

//PRINT "P" + shipPit.
//PRINT "R" + shipRoll.
//PRINT "H" + shipHdg.
//
WAIT 0.001.
