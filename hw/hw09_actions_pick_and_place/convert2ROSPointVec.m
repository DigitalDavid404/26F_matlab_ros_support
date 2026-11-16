function traj_goal = convert2ROSPointVec(mat_joint_traj, robot_joint_names, traj_steps, traj_duration, traj_goal, optns)
%--------------------------------------------------------------------------
% convert2ROSPointVec
% Converts all of the matlab joint trajectory values into a vector of ROS
% Trajectory Points. 
% 
% Make sure all messages have the same DataFormat (i.e. struct)
%
% Inputs:
% mat_joint_traj (n x q) - matrix of n trajectory points for q joint values
% robot_joint_names {} - cell of robot joint names
% traj_goal (FollowJointTrajectoryGoal)
% optns (dict) - traj_duration, traj_steps, ros class handle
%
% Outputs
% vector of TrajectoryPoints (1 x n)
%--------------------------------------------------------------------------
    
    % Get robot handle. Will work with r.point
    r = optns{'rHandle'};

    % Compute time step as duration over steps
    timeStep = traj_duration / traj_steps;
    
    % TODO: Set joint names. Note: must remove finger at index 2
    robot_joint_names(2) = []; %NOTE: 🟦🟦🟦 this removes it 
    traj_goal.Trajectory.JointNames = robot_joint_names; %🟦🟦🟦
    
  
    %% Set Points

    % Set an array of cells (currently only using 1 pt but can be extended)
    points = cell(1,traj_steps);

    % TODO: Create Point Message
    for i = 1:traj_steps    %🟦🟦🟦this makes it so if we have more than 1 point later it still works
        points{i} = rosmessage('trajectory_msgs/JointTrajectoryPoint','DataFormat','struct');


    % TODO: Fill r.point: extract each waypoint and set it as a 6x1 (use transpose)
    %Complete code here%
    r.point.Positions = transpose(mat2rosJoints(mat_joint_traj(i,:)));
    r.point.Velocities = zeros(6,1);
    r.point.Accelerations = zeros(6,1);
    r.point.TimeFromStart   = rosduration(i*timeStep,'DataFormat','struct');


        % TODO: Set inside points cell
        points{i} = r.point;
    end

    %Complete code here%

    % TODO: Copy points to traj_goal.Trajectory.Points
    %Complete code here%
    traj_goal.Trajectory.Points = [points{:}];
end