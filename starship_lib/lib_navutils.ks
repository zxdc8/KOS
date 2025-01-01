function geoDistance { //Approx in meters
	parameter geo1.
	parameter geo2.
	return (geo1:POSITION - geo2:POSITION):MAG. //SQRT((geo1:lng - geo2:lng)^2 + (geo1:lat - geo2:lat)^2) * 10472.
}
function geoDir {
	parameter geo1.
	parameter geo2.
	return ARCTAN2(geo1:LNG - geo2:LNG, geo1:LAT - geo2:LAT).
}

function rotate_2D_vec{
    PARAMETER x1.
    PARAMETER y1.
    PARAMETER theta.

    //set theta to theta * 3.14159/180.

    set x2 to x1*cos(theta) - y1*sin(theta).
    set y2 to x1*sin(theta) + y1*cos(theta).

    return list(x2,y2).
}