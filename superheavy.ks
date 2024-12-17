switch to 0.

run "./lib/lib_control.ks".
run "./lib/lib_navutils.ks".
run "./lib/lib_sysutils.ks".
run "./lib/lib_navball.ks".
run "./starship/mnvr.ks".
run "./starship/programs.ks".
run "./lib/lib_geodec.ks".

set GF1 to ship:partsdubbed("gf1")[0].
set GF2 to ship:partsdubbed("gf2")[0].
set GF3 to ship:partsdubbed("gf3")[0].
set GF4 to ship:partsdubbed("gf4")[0].
set cluster to ship:partsdubbed("cluster")[0].

wait until SHIP:PARTSDUBBED("FINLF"):length = 0.
    shRecover().
