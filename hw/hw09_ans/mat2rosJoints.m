function ros_cur_q = mat2rosJoints(mat_cur_q)
%--------------------------------------------------------------------------
% mat2rosJoints
% Set ros joint angle positions from matlab positions [pan, tilt, elbow, w1, w2, w3]. Inverse of
% ros2matlabJoints. Hard-coded here. Need to update to be robust.
% TODO: do I need to include the knuckle here?
%
% Input
% mat_cur_q [1,6]: the six joint angles of the UR5e excluding fingers
%
% Output
% ros_cur_q []: UR5e robot joint angles in this order: shoulder pan, lift, elbow, 3 wrist joint angles.
%--------------------------------------------------------------------------
    ros_cur_q = [mat_cur_q(3) mat_cur_q(2) mat_cur_q(1) mat_cur_q(4) mat_cur_q(5) mat_cur_q(6)];    
end

