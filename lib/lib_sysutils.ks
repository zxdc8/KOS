function activateSLRaptor{
    RAP1:ACTIVATE.
    RAP2:ACTIVATE.
    RAP3:ACTIVATE.
}function shutdownSLRaptor{
    RAP1:shutdown.
    RAP2:shutdown.
    RAP3:shutdown.
}
function activateVacRaptor{
    RAPV1:ACTIVATE.
    RAPV2:ACTIVATE.
    RAPV3:ACTIVATE.
}function shutdownVacRaptor{
    RAPV1:shutdown.
    RAPV2:shutdown.
    RAPV3:shutdown.
}


function checkSLRaptorLit{
    local ngood is 0.
    local RAP1good is false.
    local RAP2good is false.
    local RAP3good is false.

    if RAP1:thrust > 5{
        set RAP1good to true.
        set ngood to ngood+1.
    }
    if RAP2:thrust > 5{
        set RAP2good to true.
        set ngood to ngood+1.
    }    
    if RAP3:thrust > 5{
        set RAP3good to true.
        set ngood to ngood+1.
    }    

    if ngood = 3 {PRINT "ALL ENGINES GOOD".}.

    if ngood = 2{//find 2 good engines - 1 deactivates first, then 2, then 3
        if RAP1good{ //if a problem with raptors 2 or 3, find which one defective and then reassign raptor 1
            if RAP2good {
                set RAP1 to RAP3.
                PRINT "ENGINE 3 FAIL".
            }
            else{
                set RAP1 to RAP2.
                PRINT "ENGINE 2 FAIL".
            }
        }
    }

    if ngood = 1 {PRINT "DOUBLE ENGINE FAILURE - FATAL".}.

    return (ngood).

}

function drainshipon{
    local drain is 0.
    set drain to dmp:getmodule("ModuleResourceDrain").
    drain:setfield("Drain",1).
}
function drainshipoff{
    local drain is 1.
    set drain to dmp:getmodule("ModuleResourceDrain").
    drain:setfield("Drain",0).
}

function headerOn{
    set HDR:resources[0]:enabled to 1.
    set HDR:resources[1]:enabled to 1.
}
function headerOff{
    set HDR:resources[0]:enabled to 0.
    set HDR:resources[1]:enabled to 0.
}
function finsOn{
    local FINLF_CTL is FINLF:getmodule("ModuleSEPControlSurface").
    local FINRF_CTL is FINRF:getmodule("ModuleSEPControlSurface").
    local FINLR_CTL is FINLR:getmodule("ModuleSEPControlSurface").
    local FINRR_CTL is FINRR:getmodule("ModuleSEPControlSurface").

    FINLF_CTL:SETFIELD("DEPLOY",1).
    FINRF_CTL:SETFIELD("DEPLOY",1).
    FINRR_CTL:SETFIELD("DEPLOY",1).
    FINLR_CTL:SETFIELD("DEPLOY",1).
}
function finsOff{
    local FINLF_CTL is FINLF:getmodule("ModuleSEPControlSurface").
    local FINRF_CTL is FINRF:getmodule("ModuleSEPControlSurface").
    local FINLR_CTL is FINLR:getmodule("ModuleSEPControlSurface").
    local FINRR_CTL is FINRR:getmodule("ModuleSEPControlSurface").

    FINLF_CTL:SETFIELD("DEPLOY",0).
    FINRF_CTL:SETFIELD("DEPLOY",0).
    FINRR_CTL:SETFIELD("DEPLOY",0).
    FINLR_CTL:SETFIELD("DEPLOY",0).
}

function gridOn{
    local GF1control is GF1:getmodule("SyncModuleControlSurface").
    local GF2control is GF2:getmodule("SyncModuleControlSurface").
    local GF3control is GF3:getmodule("SyncModuleControlSurface").
    local GF4control is GF4:getmodule("SyncModuleControlSurface").

    GF1control:setfield("pitch", 0).
    GF1control:setfield("roll", 0).
    GF1control:setfield("yaw", 0).

    GF2control:setfield("pitch", 0).
    GF2control:setfield("roll", 0).
    GF2control:setfield("yaw", 0).

    GF3control:setfield("pitch", 0).
    GF3control:setfield("roll", 0).
    GF3control:setfield("yaw", 0).

    GF4control:setfield("pitch", 0).
    GF4control:setfield("roll", 0).
    GF4control:setfield("yaw", 0).

}

function gridOff{
    local GF1control is GF1:getmodule("SyncModuleControlSurface").
    local GF2control is GF2:getmodule("SyncModuleControlSurface").
    local GF3control is GF3:getmodule("SyncModuleControlSurface").
    local GF4control is GF4:getmodule("SyncModuleControlSurface").

    GF1control:setfield("pitch", 1).
    GF1control:setfield("roll", 1).
    GF1control:setfield("yaw", 1).

    GF2control:setfield("pitch", 1).
    GF2control:setfield("roll", 1).
    GF2control:setfield("yaw", 1).

    GF3control:setfield("pitch", 1).
    GF3control:setfield("roll", 1).
    GF3control:setfield("yaw", 1).

    GF4control:setfield("pitch", 1).
    GF4control:setfield("roll", 1).
    GF4control:setfield("yaw", 1).
    
}

function clusterDown{
    local clusterControl is cluster:getmodulebyindex(1).
    print cluster:getmodulebyindex(1).

    clusterControl:doevent("next engine mode").
}

function clusterUp{
    local clusterControl is cluster:getmodulebyindex(1).
    print cluster:getmodulebyindex(1).

    clusterControl:doevent("previous engine mode").
}
