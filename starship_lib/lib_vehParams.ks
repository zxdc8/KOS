function getShParams{
    // local shLanding1 is lexicon(
    //     "throttle", list(0.3, 0.01, 0.01, 0.01, 1),
    //     "velocity", list(0.15, 0, 0.005, -40, 40),
    //     "steer", list(0.15, 0, 0.005, -5, 5)
    // ).

    global shLanding1 is lexicon(
        "throttle", lexicon("kp", 0.3, "ki", 0.01, "kd", 0.01, "min", 0.01, "max", 1),
        "velocity", lexicon("kp",0.15, "ki", 0, "kd", 0.005, "min", -40, "max", 40),
        "steer", lexicon("kp", 0.5, "ki", 0, "kd", 0.005, "min", -5, "max", 5)
    ).

    // local shLanding2 is lexicon(
    //     "throttle", list(0.3, 0.01, 0.01, 0.01, 1),
    //     "velocity", list(0.15, 0, 0.005, -40, 40),
    //     "steer", list(0.15, 0, 0.005, -5, 5)
    // ).

    set guidanceParams to list(shLanding1).

    return guidanceParams.
}