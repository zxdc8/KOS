function ssSteeringSetup{
//Need two PIDs for each axis e.g. pitch
//1) adjust control input to achieve required torque for pitch RATE
//2) adjust pitch rate to achieve required PITCH

set pitchRatePID to pidLoop(0.01, 0.00, 0.00).
set rollRatePID to pidLoop(0.01, 0.00, 0.00).
set yawRatePID to pidLoop(0.01, 0.00, 0.00).

set pitchCmdPID to pidLoop(0.01, 0.00, 0.00).
set rollCmdPID to pidLoop(0.01, 0.00, 0.00).
set yawCmdPID to pidLoop(0.01, 0.00, 0.00).

set controlStick to ship:control.

}

function ssSteeringUpdate{
    declare parameter desPitch, desRoll, desYaw.
    //Update PIDs 
    set pitchRatePID:setpoint to desPitch.
    set rollRatePID:setpoint to desRoll.
    set yawRatePID:setpoint to desYaw.

    set pitchCmdPID:setpoint to pitchRatePID:update(time:seconds, pitch_for()).
    set rollCmdPID:setpoint to pitchRatePID:update(time:seconds, roll_for()).
    set yawCmdPID:setpoint to pitchRatePID:update(time:seconds, compass_for()).
    set angular_vel to get_ang_vel().

    set controlStick:pitch to pitchCmdPID:update(time:seconds, angular_vel:x).
    set controlStick:roll to pitchCmdPID:update(time:seconds, angular_vel:y).
    set controlStick:yaw to pitchCmdPID:update(time:seconds, angular_vel:z).
}

FUNCTION get_ang_vel {//The returned structure can be queried using the suffixes :PITCH, :YAW, and :ROLL to get the rate of rotation in that axis
  LOCAL angVel is SHIP:ANGULARVEL.
  LOCAL shipFacing IS SHIP:FACING.
  LOCAL pitchRate IS VDOT(angVel ,shipFacing:STARVECTOR).
  LOCAL yawRate IS VDOT(angVel ,shipFacing:TOPVECTOR).
  LOCAL rollRate IS VDOT(angVel ,shipFacing:FOREVECTOR).
  RETURN v(pitchRate,yawRate,rollRate).
}