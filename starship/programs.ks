function simplehop{
    print "------------------".
    print "SIMPLE HOP".
    print "------------------".
    set programTgt to ship:geoposition.
    shipSimpleAscent(90,88,30000).
    //bellyFlop(programTgt).
    terminalFlop(programTgt).
    targetLanding(programTgt).
    print "------------------".
    print "PROGRAM END".
    print "------------------".
    WAIT 2.
}

function bellyFlopToLand{
    set programTgt to latlng(28.5490773930942,-80.6559373483508).
    //bellyFlop(programTgt).
    terminalFlop(programTgt).
    targetLanding(programTgt).
    print "------------------".
    print "PROGRAM END".
    print "------------------".
    WAIT 2.
}

function tgtLand{
    set programTgt to latlng(28.5490773930942,-80.6559373483508).
    targetLanding(programTgt).
    print "------------------".
    print "PROGRAM END".
    print "------------------".
    WAIT 2.
}

function primaryAscent{
    set programTgt to latlng(28.5490773930942,-80.6559373483508).
    primaryBoosterAscent(090, 82.5).
}

function shLanding{
    set programTgt to latlng(28.5490773930942,-80.6559373483508).
    shBoostback(programTgt).
}