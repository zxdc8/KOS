 run navutils.ks.
 run lib_navball.ks.
 set landingTgt to latlng(28.5490773930942,-80.6559373483508).
 print rotate_2D_vec(1,0,90).
 until false{
    set northVel to vDot(ship:velocity:surface, ship:north:forevector).
    set eastVel to vDot(ship:velocity:surface, ship:north:starvector).

    //set northSteer to vDot(ship:facing:forevector, ship:north:forevector).
    //set eastSteer to vDot(ship:facing:forevector, ship:north:starvector).

    //set relPos to ship:north:inverse * landingTgt:position.
    set dNorth to landingTgt:position * ship:north:forevector.
    set dEast to landingTgt:position * ship:north:starvector.

    set dxdy to rotate_2D_vec(dNorth,dEast, -compass_for()).
    print dNorth.
    print dEast.
    print dxdy.
    //print compass_for().
 }