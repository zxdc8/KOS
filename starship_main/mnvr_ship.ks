function shipSimpleAscent{

    local parameter selHeading, selPitch, selAlt.
    LOCK THROTTLE TO 1.0.

    PRINT "Counting down:".
    FROM {local countdown is 3.} UNTIL countdown = 0 STEP {SET countdown to countdown - 1.} DO {
        PRINT "..." + countdown.
        WAIT 1. // pauses the script here for 1 second.
    }

    activateSLRaptor().

    when RAP1:thrust > 5 then {
        set ngood to checkSLRaptorLit().
        
        if ngood < 3{
            PRINT "ABORT - ENGINE FAILURE".
            shutdownSLRaptor().
            return.
        }
    }

    

    //Ascent Phase
    PRINT "ASCENT PHASE...".

    SAS ON.

    UNTIL ALTITUDE > 100{
        
        }
        
    PRINT "ROLL PROGRAM...".
    SAS OFF.
    UNTIL ALTITUDE >=500{
        LOCK STEERING TO HEADING(selHeading,89.9,180).
    }

    PRINT "PITCHING...".

    UNTIL APOAPSIS >=selAlt{
        LOCK STEERING TO HEADING(selHeading,selPitch,180).
    }

    //Coast to apogee
    LOCK THROTTLE TO 0.0.
    shutdownSLRaptor().
    LOCK STEERING TO ship:velocity:surface.
    RCS ON.
    drainshipon().
    headerOn().

    PRINT "WAITING FOR APOGEE...".
    UNTIL VERTICALSPEED < 50{	
        WAIT 0.01.
    }

    drainshipoff().

}

function bellyFlop{

    local parameter landingTgt.
    
    finsOn().

    headerOn.

    set steer to heading(0,0,0).
    lock steering to steer.

    set slopePID to pidLoop(0.15,0.000,0.01).
    set slopePID:minoutput to -75.
    set slopePID:maxoutput to 75.

    set pitchAngPID to pidLoop(3,0.1,0.1).
    set pitchAngPID:minoutput to -10.
    set pitchAngPID:maxoutput to 10.

    set rollAngPID to pidLoop(1,0,0).

    set backuprollcontrolanglerange to steeringManager:rollcontrolanglerange.
    set backupmaxstoppingtime to steeringManager:maxstoppingtime.
    //SET STEERINGMANAGER:ROLLPID:kp TO 2*STEERINGMANAGER:ROLLPID:kp.
    set steeringManager:rollcontrolanglerange to 60.
    set steeringManager:maxstoppingtime to 0.5.
    set STEERINGMANAGER:rollPID:KP TO 0.15.
    set STEERINGMANAGER:rollPID:Kd TO 0.01.
    set STEERINGMANAGER:pitchPID:KP TO 0.15.
    

    set tgtDist to geoDistance(landingTgt, ship:geoposition).
    //28°32'56''N
    //80°39'21''W

    until tgtDist<5000{

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
        set desiredDist to 0. //altitude/tan(80).

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

        if tgtDist < 500{
            set tgtBrg to compass_for().
        }

        set steer to heading(tgtBrg, -desiredPitchAngle, 0).

        }
    }

function terminalFlop{

    local parameter landingTgt.
    
    finsOn().

    headerOn.

    set steer to heading(0,0,0).
    lock steering to steer.

    set pidVNorth to pidLoop(0.2, 0.00, 0.05).
    set pidVNorth:minoutput to -40.
    set pidVNorth:maxoutput to 40. 
    
    set pidVEast to pidloop(0.2, 0.00, 0.05).
    set pidVEast:minoutput to -40.
    set pidVEast:maxoutput to 40.   

    ///set pidSteerNorth to pidLoop(1.1, 0.005, 0.05).
    ///set pidSteerNorth:minoutput to -5.
    ///set pidSteerNorth:maxoutput to 5. 

    ///set pidSteerEast to pidloop(1.1, 0.005, 0.05).

    ///set pidSteerEast:minoutput to -5.
    ///set pidSteerEast:maxoutput to 5.   

    set pitchAngPID to pidLoop(0.3,0.0,0.0).
    set pitchAngPID:minoutput to -10.
    set pitchAngPID:maxoutput to 10.

    set rollAngPID to pidLoop(5,0,0).
    set rollAngPID:minoutput to -25.
    set rollAngPID:maxoutput to 25.

    //ssSteeringSetup().
    set shipHdg to compass_for().

    set steer to heading(0,0,0).
    lock steering to steer.
    set preTerminalPhase to true.

    set backuprollcontrolanglerange to steeringManager:rollcontrolanglerange.
    set backupmaxstoppingtime to steeringManager:maxstoppingtime.
    //SET STEERINGMANAGER:ROLLPID:kp TO 2*STEERINGMANAGER:ROLLPID:kp.
    set steeringManager:rollcontrolanglerange to 60.
    set steeringManager:maxstoppingtime to 0.5.
    set STEERINGMANAGER:rollPID:KP TO 0.4.
    set STEERINGMANAGER:rollPID:Kd TO 0.01.
    set STEERINGMANAGER:pitchPID:KP TO 0.65.
    set STEERINGMANAGER:rollts to 0.3.

    //28°32'56''N
    //80°39'21''W

    until altitude < 500{

        set northVel to vDot(ship:velocity:surface, ship:north:forevector).
        set eastVel to vDot(ship:velocity:surface, ship:north:starvector).

        //set northSteer to vDot(ship:facing:forevector, ship:north:forevector).
        //set eastSteer to vDot(ship:facing:forevector, ship:north:starvector).

        //set relPos to ship:north:inverse * landingTgt:position.
        set dNorth to landingTgt:position * ship:north:forevector.
        set dEast to landingTgt:position * ship:north:starvector.

        set dxdy to rotate_2D_vec(dNorth,dEast, -compass_for()).

        //set northVelTgt to pidVNorth:update(time:seconds, dNorth).
        //set eastVelTgt to pidVEast:update(time:seconds, dEast).

        set pidVNorth:setpoint to 00.
        set xVelTgt to pidVNorth:update(time:seconds, dxdy[0]).
        set yVelTgt to pidVEast:update(time:seconds, dxdy[1]).

        //set bodyVelTgt to rotate_2D_vec(northVelTgt,eastVelTgt, -compass_for()).
        set bodyVel to rotate_2D_vec(northVel,eastVel, -compass_for()).

        set pitchAngPID:setpoint to -xVelTgt.//-bodyVelTgt[0].
        set rollAngPID:setpoint to -yVelTgt.//-bodyVelTgt[1].

        set desiredPitchAngle to pitchAngPID:UPDATE(TIME:seconds, bodyVel[0]).
        set desiredRollAngle to  rollAngPID:UPDATE(TIME:seconds, bodyVel[1]).
        
        set tgtDist to geoDistance(landingTgt, ship:geoposition).
        if tgtDist < 500{
            set tgtBrg to compass_for().
            set preTerminalPhase to false.
        } else {
            set tgtBrg to landingTgt:heading.
        }

        set steer to heading(tgtBrg, -desiredPitchAngle, -desiredRollAngle).

        print "tgtbrg" + tgtBrg.
        print "dx:"  + dxdy[0].
        print "dy:"  + dxdy[1].
        print "desvx:"        + xVelTgt.// -bodyVelTgt[0].
        print "desvy:" + yVelTgt.//-bodyVelTgt[1].
        print "vx:"        + -bodyVel[0].
        print "vy:" + -bodyVel[1].
        print "Desired Pitch:" + desiredPitchAngle.
        print "Desired Roll:" + desiredRollAngle.

        }
    }    

function simpleLanding{
    set steeringManager:rollcontrolanglerange to backuprollcontrolanglerange.
    set steeringManager:maxstoppingtime to backupmaxstoppingtime.
    //FLIP TIME
    PRINT "FLIP...".
    headerOn().
    activateSLRaptor().

    //Define PID and Targets

    LOCK VS to VERTICALSPEED.

    SET Kp TO 0.3.
    SET Ki TO 0.01.
    SET Kd TO 0.01.
    SET pidThrott TO PIDLOOP(Kp, Ki, Kd).


    SET pidThrott:MINOUTPUT TO 0.05.
    SET pidThrott:MAXOUTPUT TO 1.

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
        SET thrott to pidThrott:UPDATE(TIME:SECONDS, VS).

        WAIT 0.01.
        SET TGTVS TO -(0.5 + bounds_box:BOTTOMALTRADAR/5).
        SET pidThrott:SETPOINT TO TGTVS.
        
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

        when RAP1:thrust>5 then{
            checkSLRaptorLit.
        }
    }	
}

function targetLanding{
    parameter landingTgt.
    
    set steeringManager:rollcontrolanglerange to backuprollcontrolanglerange.
    set steeringManager:maxstoppingtime to backupmaxstoppingtime.

    set steeringManager:maxstoppingtime to 0.5.
    
    //FLIP TIME
    PRINT "FLIP...".
    headerOn().
    activateSLRaptor().
    set raptorsLit to false.

    //Define PID and Targets


    SET pidThrott TO PIDLOOP(0.3, 0.01, 0.01).

    SET pidThrott:MINOUTPUT TO 0.05.
    SET pidThrott:MAXOUTPUT TO 1.

    SET thrott TO 0.65.
    LOCK THROTTLE TO thrott.

    set desSteer to UP.

    LOCK STEERING TO desSteer.

    SET complete TO 0.

    set pidVNorth to pidLoop(0.15, 0.00, 0.005).
    set pidVNorth:minoutput to -40.
    set pidVNorth:maxoutput to 40. 
    
    set pidVEast to pidloop(0.15, 0.00, 0.005).
    set pidVEast:minoutput to -40.
    set pidVEast:maxoutput to 40.   

    set pidSteerNorth to pidLoop(0.4, 0.05, 0.05).
    set pidSteerNorth:minoutput to -5.
    set pidSteerNorth:maxoutput to 5. 

    set pidSteerEast to pidloop(0.4, 0.05, 0.05).

    set pidSteerEast:minoutput to -5.
    set pidSteerEast:maxoutput to 5.   

    //SET PIDHS to PIDLOOP(0.015, 0.000, 0.000).
    //SET PIDHS:MINOUTPUT TO 0.0.
    //SET PIDHS:MAXOUTPUT TO 0.3.
    //SET PIDHS:SETPOINT TO 0.

    local gravity is (constant():g*body:mass)/(body:radius^2).
    local bounds_box is ship:bounds.

    set mixFactor to 0.3.

    wait 2.

    UNTIL complete  {

        if ship:velocity:surface:mag < 50 and RAP1:ignition{
            RAP1:shutdown.
            act1:setfield("actuate out",1).
            set mixFactor to 0.5.
            //SET PIDHS:Kp to 0.1.
            //SET PIDHS:Kd to 0.05.
        }
        if ship:velocity:surface:mag < 20 and RAP2:ignition{
            RAP2:shutdown.
            act2:setfield("actuate out",1).
            set steeringManager:maxstoppingtime to 1.
            set mixFactor to 0.3.
            //SET PIDHS:Kp to 0.2.
            //SET PIDHS:Kd to 0.1.
        }
        //if ship:velocity:surface:mag <5 {
        //    SET PIDHS:Kp to 0.4.
        //    return false.
        //}
        

        if bounds_box:BOTTOMALTRADAR < 0.1 {
            SET complete TO 1.
            SET thrott to 0.
            UNLOCK steering.
            return false.
            }
//
        if RAP3:thrust >5 and not raptorsLit.{
            checkSLRaptorLit.
            set raptorsLit to true.
            RAP1:shutdown.
            act1:setfield("actuate out",1).
        }

        set northVel to vDot(ship:velocity:surface, ship:north:forevector).
        set eastVel to vDot(ship:velocity:surface, ship:north:starvector).

        //set northSteer to vDot(ship:facing:forevector, ship:north:forevector).
        //set eastSteer to vDot(ship:facing:forevector, ship:north:starvector).

        //set relPos to ship:north:inverse * landingTgt:position.
        set dNorth to landingTgt:position * ship:north:forevector.
        set dEast to landingTgt:position * ship:north:starvector.

        SET TGTVS TO -(0.01 + 0.2*bounds_box:BOTTOMALTRADAR).
        //set tgtvs to 0.
        SET pidThrott:SETPOINT TO TGTVS.
        SET thrott to pidThrott:UPDATE(TIME:SECONDS, VERTICALSPEED).
        
        set northVelTgt to pidVNorth:update(time:seconds, dNorth).
        set eastVelTgt to pidVEast:update(time:seconds, dEast).

        if bounds_box:BOTTOMALTRADAR < 20 {
            set northVelTgt to 0.
            set eastVelTgt to 0.
        }

        set pidSteerNorth:setpoint to -northVelTgt.
        set pidSteerEast:setpoint to -eastVelTgt.

        set northSteer to pidSteerNorth:update(time:seconds, northVel).
        set eastSteer to pidSteerEast:update(time:seconds, eastVel).

        
        //ship:north:forevector * northSteer

        set steeringVector to northSteer * ship:north:forevector + eastSteer * ship:north:starvector.
        //set steeringVector to v(0, 0, 0).
        
        SET iArrow TO VECDRAW(
            V(0,0,0),
            10*steeringVector,
            RGB(1,0,0),
            "steeringvector?",
            1.0,
            TRUE,
            0.2,
            TRUE,
            TRUE
            ).

        SET iiArrow TO VECDRAW(
            V(0,0,0),
            100*ship:north:forevector,
            RGB(0,1,0),
            "forevector?",
            1.0,
            TRUE,
            0.2,
            TRUE,
            TRUE
            ).
        SET iiiArrow TO VECDRAW(
            V(0,0,0),
            100*ship:north:starvector,
            RGB(0,0,1),
            "starvector?",
            1.0,
            TRUE,
            0.2,
            TRUE,
            TRUE
            ).

        //SET hComp to -vectorExclude(up:vector, ship:velocity:surface).
        //SET hSteer to PIDHS:UPDATE(TIME:SECONDS, hComp:mag).
        //PRINT hSteer.	
        //PRINT hComp:mag.

        print dNorth.
        print dEast.
        print northVelTgt.
        print eastVelTgt.
        print northVel.
        print eastVel.
        print northSteer.
        print eastSteer.
        
        set desSteer to lookdirup(up:vector * gravity + mixFactor*steeringVector ,ship:facing:topvector).
        



            WAIT 0.001.
    }	


}