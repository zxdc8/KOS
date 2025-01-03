function getShParams{
    // local shLanding1 is lexicon(
    //     "throttle", list(0.3, 0.01, 0.01, 0.01, 1),
    //     "velocity", list(0.15, 0, 0.005, -40, 40),
    //     "steer", list(0.15, 0, 0.005, -5, 5)
    // ).

    local shLanding1 is lexicon(
        "throttle", lexicon("kp", 0.3, "ki", 0.01, "kd", 0.01, "min", 0.01, "max", 1),
        "velocity", lexicon("kp",0.15, "ki", 0, "kd", 0.005, "min", -40, "max", 40),
        "steer", lexicon("kp", 0.3, "ki", 0, "kd", 0.1, "min", -5, "max", 5)
    ).

    local shLanding2 is lexicon(
        "throttle", lexicon("kp", 0.3, "ki", 0.01, "kd", 0.01, "min", 0.01, "max", 1),
        "velocity", lexicon("kp",0.15, "ki", 0, "kd", 0.005, "min", -200, "max", 200),
        "steer", lexicon("kp", 0.5, "ki", 0, "kd", 0.005, "min", -15, "max", 15)
    ).

    local shBoostBack1 is lexicon(
        "throttle", lexicon("kp", 10, "ki", 0.0, "kd", 0.0, "min", 0.8, "max", 1),
        "steer", lexicon("kp", 500, "ki", 20, "kd", 5, "min", -10, "max", 10)
    ).

    local shGlide1 is  lexicon(
        "steerAlong", lexicon("kp", 5, "ki", 0.0, "kd", 0.0, "min", -30, "max", 30),
        "steerAcross", lexicon("kp", 5, "ki", 0.0, "kd", 0.0, "min", -30, "max", 30),
        "throttle", lexicon("kp", 10, "ki", 0.0, "kd", 0.0, "min", -10, "max", 10)
    ).

    return list(shLanding1, shLanding2, shBoostBack1, shGlide1).
}
