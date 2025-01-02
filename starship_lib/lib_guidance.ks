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

function landingPIDUpdate{
    local parameter landingTgt.
    
    local northVel to vDot(ship:velocity:surface, ship:north:forevector).
    local eastVel to vDot(ship:velocity:surface, ship:north:starvector).

    //set relPos to ship:north:inverse * landingTgt:position.
    local dNorth to landingTgt:position * ship:north:forevector.
    local dEast to landingTgt:position * ship:north:starvector.
    
    local northVelTgt to pidVNorth:update(time:seconds, dNorth).
    local eastVelTgt to pidVEast:update(time:seconds, dEast).

    local mixFactor to 0.3.
    local gravity is (constant():g*body:mass)/(body:radius^2).
    local bounds_box is ship:bounds.

    if bounds_box:BOTTOMALTRADAR < 20 {
        set northVelTgt to 0.
        set eastVelTgt to 0.
    }

    set pidSteerNorth:setpoint to -northVelTgt.
    set pidSteerEast:setpoint to -eastVelTgt.

    local northSteer to pidSteerNorth:update(time:seconds, northVel).
    local eastSteer to pidSteerEast:update(time:seconds, eastVel).

    SET TGTVS TO -(0.02 + 0.1*bounds_box:BOTTOMALTRADAR).
    SET pidThrott:SETPOINT TO TGTVS.

    local steeringVector to northSteer * ship:north:forevector + eastSteer * ship:north:starvector.
    local desThrott to pidThrott:UPDATE(TIME:SECONDS, VERTICALSPEED).

    set desSteer to lookdirup(up:vector * gravity + mixFactor*steeringVector ,ship:facing:topvector).

    clearScreen.
    set terminal:width to 50.
    set terminal:height to 36.

 

    print "----TGT--|--ACT---" at (5,4).
    print "----_DISTANCE-----" at (5,5).
    print round(dNorth,2) at(5,6).
    print round(dEast,2) at (8,6).
    print "-----VELOCITY-----" at(5,7).
    print round(northVelTgt,2) at(5,8).
    print round(eastVelTgt,2) at(5,10).
    print round(northVel,2) at(8,8).
    print round(eastVel,2) at(8,10).
    print "------Steer-------" at (3,11).
    print round(northSteer, 2) at(5,12).
    print round(eastSteer, 2) at(5,14).

    global guidanceCommand is lexicon(
        "steering", desSteer, 
        "throttle", desThrott
        ).

    return guidanceCommand.

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