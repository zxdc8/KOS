
function shBoostBack{
    local parameter landingTgt.
    
    local guidanceCommand is lexicon().
    local guidanceParams is lexicon().
    local steer is 1.
    local thrott is 0.
    local now is 0.
  
    //wait 5.
    
    

    stage.
    wait 1.
    stage.

    rcs on.

    set SHIP:CONTROL:FORE to 1. //ullage
    set now to time:seconds.
    WAIT until time:seconds > now + 3.
    SET SHIP:CONTROL:FORE to 0.0.
    set thrott to 0.9.
    lock throttle to thrott.

    addons:tr:setTarget(landingTgt).
    
    set guidanceParams to getShParams().

    boostBackPIDInit(guidanceParams[2]).
 
    set pidAlong:setpoint to 0/180.

    set STEERINGMANAGER:yawts to 0.3.
    set STEERINGMANAGER:pitchts to 0.3.
    
    set steer to up.

    lock steering to steer.

    wait 10.

    set now to time:seconds.

    //clusterUp().
    when abs(bodyError[0]) < 3/60 then{
        clusterDown().
    }

    when time:seconds > now + 10 then{
        clusterUp.
    }

    set bodyError to list(-1).

    until bodyError[0] > pidAlong:setpoint{ 

        set guidanceCommand to boostBackPIDUpdate().
         
        set steer to guidanceCommand:steering.
        set thrott to guidanceCommand:throttle.
        set bodyError to guidanceCommand:bodyError. 
        //print bodyError[1].
        //print landingTgt:heading - steerCorrection.
        wait 0.001.
    }

    set thrott to 0.
    clusterUp().
    
    set steer to up.
    wait until altitude < 100000.
    

}

function shGlide{
    local parameter landingTgt.
    
    local guidanceCommand is lexicon().
    local guidanceParams is lexicon().
    local steer is up.
    local thrott is 0.
    local suicideAlt is 0.
    local accel is 0.
    local now is 0.
    set steeringManager:rollcontrolanglerange to 30.
    gridOn().

    addons:tr:setTarget(landingTgt).
    set guidanceParams to getShParams().

    glidePIDInit(guidanceParams[3]).

    lock steering to steer.
  
    lock accel to ship:availableThrust/ship:mass - 9.81 + 10.
    lock suicideAlt to verticalSpeed^2/(2*accel). 
    
   
    until altitude < suicideAlt+1000{
        set guidanceCommand to glidePIDUpdate().
        set steer to guidanceCommand:steering.
        print steer:vector:x.
        set accel to ship:availableThrust/ship:mass - 9.81.
        set suicideAlt to verticalSpeed^2/(2*accel). 

        wait 0.001.
    }

    // wait until altitude < suicideAlt + 1000.
    // set pidThrott to pidLoop(0.4,0,0.05).
    // set pidThrott:minoutput to 0.1.
    // lock steering to srfRetrograde:vector.
    // until ship:velocity:surface:mag < 300{
        
    //     set pidThrott:setpoint to -0.9*(2*accel*(altitude-1000)) ^ 0.5.
    //     //print pidThrott:setpoint.
    //    // print verticalSpeed.
    //     set throttLdg to pidThrott:update(time:seconds, verticalSpeed).
    //     //print throttLdg.
    //     print crossVector:mag.
    //     print alongVector:mag.
    //     wait 0.001.
    // }

}

function shtargetLanding{
    local parameter landingTgt.
    local guidanceCommand is lexicon().
    local guidanceParams is lexicon().

    local complete is 0.

    local steer to up.
    lock steering to steer.
    
    local thrott to 0.5.
    lock throttle to thrott.
    local params is 0.
    set guidanceParams to getShParams().

    landingPIDInit(guidanceParams[1]).

    when altitude < 1000 then {
        landingPIDChangeParams(guidanceParams[0]).
        print "parameters_updated".
    }

    until complete{
        set guidanceCommand to landingPIDUpdate(landingTgt).
        set steer to guidanceCommand:steering.
        set thrott to guidanceCommand:throttle.
        WAIT 0.001.
    }	


}