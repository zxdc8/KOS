GLOBAL stage1 is lexicon(
    "Name", "Superheavy",
    "massTotal", 4937519,
    "massFuel", 3263450,
    "engines", LIST(LEXICON("isp", 328.0, "thrust", 45770000,"tag","cluster")),
    "staging", LEXICON("jettison", FALSE, "ignition", FALSE)
).

// GLOBAL stage2 is lexicon(
//     "Name", "Starship",
//     "massTotal", 1339623,
//     "massFuel", 1186549,
//     "engines", LIST(LEXICON("isp", 347.0, "thrust", 2255500*3),LEXICON("isp", 378.0, "thrust", 2530000*3)),
//     "staging", LEXICON("jettison", true, "ignition", true, "ullage", "hot",
//                     "waitBeforeJettison", 3,
//                     "waitBeforeIgnition", 2)
// ).

GLOBAL stage22 is lexicon(
    "Name", "Starship",
    "massTotal", 1339623,
    "massFuel", 1186549,
    "engines", LIST(LEXICON("isp", 347.0, "thrust", 2255500*3),LEXICON("isp", 378.0, "thrust", 2530000*3)),
    "staging", LEXICON("jettison", FALSE, "ignition", FALSE)
).

GLOBAL vehicle is list(stage22).

GLOBAL sequence is list(LEXICON("time", -4, "type", "stage", "message", "NK-33 ignition"),
                        LEXICON("time", 0, "type", "stage", "message", "LIFTOFF!"),
                        LEXICON("time", 130, "type", "stage", "message", "LIFTOFF!"),
                        LEXICON("time", 132, "type", "stage", "message", "LIFTOFF!")
                        ).

GLOBAL controls IS LEXICON(
					"launchTimeAdvance", 120,
					"verticalAscentTime", 12,
					"pitchOverAngle", 4,
					"upfgActivation", 140
).

GLOBAL mission IS LEXICON(
					"payload", 43862,
					"periapsis", 300,
					"apoapsis", 300,
					"inclination", 32.521,
					"LAN", 270 ,
					"direction", "nearest"
).