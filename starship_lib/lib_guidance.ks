function landingPIDInit{

    local parameter gains.

    set pidThrott TO PIDLOOP(gains:throttle:kp, gains:throttle:ki, gains:throttle:kd).
    SET pidThrott:MINOUTPUT TO gains:throttle:min.
    SET pidThrott:MAXOUTPUT TO gains:throttle:max.

    set pidVNorth to pidLoop(gains:velocity:kp, gains:velocity:ki, gains:velocity:kd).
    set pidVNorth:minoutput to gains:velocity:min.
    set pidVNorth:maxoutput to gains:velocity:max. 

    set pidVEast to pidloop(gains:velocity:kp, gains:velocity:ki, gains:velocity:kd).
    set pidVEast:minoutput to gains:velocity:min.
    set pidVEast:maxoutput to gains:velocity:max.  

    set pidSteerNorth to pidLoop(gains:steer:kp, gains:steer:ki, gains:steer:kd).
    set pidSteerNorth:minoutput to gains:steer:min.
    set pidSteerNorth:maxoutput to gains:steer:max.

    set pidSteerEast to pidloop(gains:steer:kp, gains:steer:ki, gains:steer:kd).
    set pidSteerEast:minoutput to gains:steer:min..
    set pidSteerEast:maxoutput to gains:steer:max.   

    //return list(pidThrott, pidVNorth, pidVEast, pidSteerNorth, pidSteerEast).

}

function landingPIDChangeParams{
    
    local parameter gains.

    set pidThrott:Kp to gains:throttle:kp.
    set pidThrott:Ki to gains:throttle:ki.
    set pidThrott:Kd to gains:throttle:kd.
    set pidThrott:minoutput to gains:throttle:min.
    set pidThrott:maxoutput to gains:throttle:max.

    set pidVNorth:Kp to gains:velocity:kp.
    set pidVNorth:Ki to gains:velocity:ki.
    set pidVNorth:Kd to gains:velocity:kd.
    set pidVNorth:minoutput to gains:velocity:min.
    set pidVNorth:maxoutput to gains:velocity:max.

    set pidVEast:Kp to gains:velocity:kp.
    set pidVEast:Ki to gains:velocity:ki.
    set pidVEast:Kd to gains:velocity:kd.
    set pidVEast:minoutput to gains:velocity:min.
    set pidVEast:maxoutput to gains:velocity:max.

    set pidSteerNorth:Kp to gains:steer:kp.
    set pidSteerNorth:Ki to gains:steer:ki.
    set pidSteerNorth:Kd to gains:steer:kd.
    set pidSteerNorth:minoutput to gains:steer:min.
    set pidSteerNorth:maxoutput to gains:steer:max.

    set pidSteerEast:Kp to gains:steer:kp.
    set pidSteerEast:Ki to gains:steer:ki.
    set pidSteerEast:Kd to gains:steer:kd.
    set pidSteerEast:minoutput to gains:steer:min.
    set pidSteerEast:maxoutput to gains:steer:max.
}

function landingPIDUpdate{
    local parameter landingTgt.
    
    local northVel to vDot(ship:velocity:surface, ship:north:forevector).
    local eastVel to vDot(ship:velocity:surface, ship:north:starvector).

    //set relPos to ship:north:inverse * landingTgt:position.
    local dNorth to landingTgt:position * ship:north:forevector.
    local dEast to landingTgt:position * ship:north:starvector.
    
    local northVelTgt to pidVNorth:update(time:seconds, dNorth).
    local eastVelTgt to pidVEast:update(time:seconds, dEast).

    
    local gravity is (constant():g*body:mass)/(body:radius^2).
    local bounds_box is ship:bounds.
    local accel is ship:availableThrust/ship:mass.

    local steeringVector is up.
    local desThrott is 0.5.
    local mixFactor is 0.3.
    local desSteer is up.


    SET TGTVS TO  -0.9*(2*accel*(altitude)) ^ 0.5.
    if bounds_box:bottomaltradar< 3000{
        set tgtvs to -0.1 * (bounds_box:bottomaltradar).  
    }
    if bounds_box:BOTTOMALTRADAR < 50 {
        set northVelTgt to 0.
        set eastVelTgt to 0.
        set TGTVS to -2.
    }

    set pidSteerNorth:setpoint to -northVelTgt.
    set pidSteerEast:setpoint to -eastVelTgt.

    local northSteer to pidSteerNorth:update(time:seconds, northVel).
    local eastSteer to pidSteerEast:update(time:seconds, eastVel).

    SET pidThrott:SETPOINT TO TGTVS.

    set steeringVector to northSteer * ship:north:forevector + eastSteer * ship:north:starvector.
    set desThrott to pidThrott:UPDATE(TIME:SECONDS, VERTICALSPEED).

    set mixFactor to 0.3.
    set desSteer to lookdirup(up:vector * gravity + mixFactor*steeringVector ,ship:facing:topvector).

    if ship:velocity:surface:mag > 300 {
        set desSteer to lookDirUp(srfRetrograde:vector, up:vector).
    }

    clearScreen.
    set terminal:width to 50.
    set terminal:height to 36.

    print "----TGT--|--ACT---" at (5,4).
    print "----_DISTANCE-----" at (5,5).
    print round(dNorth,2) at(6,6).
    print round(dEast,2) at (17,6).
    print "-----VELOCITY-----" at(5,7).
    print round(northVelTgt,2) at(6,8).
    print round(eastVelTgt,2) at(6,10).
    print round(northVel,2) at(17,8).
    print round(eastVel,2) at(17,10).
    print "------Steer-------" at (3,11).
    print round(northSteer, 2) at(6,12).
    print round(eastSteer, 2) at(6,13).
    print "------V/S---------" at (6,14).
    print round(TGTVS, 2) at(6,15).

    
    return lexicon(
            "steering", desSteer,
            "throttle", desThrott
    ).
 

}


function boostBackPIDInit{
    local parameter gains.
    set pidAlong to pidLoop(10,0,0).
    set pidAcross to pidloop(500,20,5).

    set pidAlong TO PIDLOOP(gains:throttle:kp, gains:throttle:ki, gains:throttle:kd).
    SET pidAlong:MINOUTPUT TO gains:throttle:min.
    SET pidAlong:MAXOUTPUT TO gains:throttle:max.

    set pidAcross TO PIDLOOP(gains:steer:kp, gains:steer:ki, gains:steer:kd).
    SET pidAcross:MINOUTPUT TO gains:steer:min.
    SET pidAcross:MAXOUTPUT TO gains:steer:max.
}

function latLongToCrossTrack{
    set latError to addons:tr:impactPos:lat - addons:tr:getTarget:lat.
    set lngError to addons:tr:impactPos:lng - addons:tr:getTarget:lng.
    set hdg to -addons:tr:getTarget:heading.
    set bodyError to rotate_2D_vec(latError,lngError, hdg).
}

function boostBackPIDUpdate{
    latLongToCrossTrack().

    local steerCorrection to pidAcross:update(time:seconds, bodyError[1]). 
    local desSteer to heading(addons:tr:getTarget:heading + steerCorrection ,0, 0).
    local desThrott to pidAlong:update(time:seconds, bodyError[0]).

    return lexicon(
        "steering", desSteer, 
        "throttle", desThrott,
        "bodyError", bodyError
        ).

}

function glidePIDInit{
    local parameter gains.

    set pidAlong TO PIDLOOP(gains:steerAlong:kp, gains:steerAlong:ki, gains:steerAlong:kd).
    SET pidAlong:MINOUTPUT TO gains:steerAlong:min.
    SET pidAlong:MAXOUTPUT TO gains:steerAlong:max.

    set pidAcross TO PIDLOOP(gains:steerAcross:kp, gains:steerAcross:ki, gains:steerAcross:kd).
    SET pidAcross:MINOUTPUT TO gains:steerAcross:min.
    SET pidAcross:MAXOUTPUT TO gains:steerAcross:max.
}

function glidePIDUpdate{
    latLongToCrossTrack().

    local tgtDirection to lookDirUp(addons:tr:getTarget:position, up:vector).
    local crossVector to tgtDirection:starvector.
    local alongVector to tgtDirection:upvector.
    local steerCrossCorrection to pidAcross:update(time:seconds, -bodyError[1]).
    local steerAlongCorrection to pidAlong:update(time:seconds, -bodyError[0]).
    local desSteer to lookDirUp(srfRetrograde:vector + crossVector * steerCrossCorrection + alongVector * steerAlongCorrection, up:forevector).

    return lexicon(
        "steering", desSteer
        ).

}


function landingGuidanceArrows{
    
    local parameter steeringVector.

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
}