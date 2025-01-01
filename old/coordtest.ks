run lib_geodec.ks.

set lat to 30.
set lng to -80.

set testpos to latlng(ship:geoposition:lat+1, ship:geoposition:lng+1).

print geo2dec(lat, lng, 0).

print geo2dec(ship:geoposition:lat, ship:geoposition:lng, altitude).

print  ship:north:inverse * testpos:position.

