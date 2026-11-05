%% HW07 Services - EECE/ME 4523 Mechatronics

%% 00 Connect to ROS (use your own masterhost IP address)
clc
clear
rosshutdown;
pause(2);


%% Set IP address for master and node:
masterHostIP =  "192.168.1.81"; %"10.51.75.215"; 
nodeHostIP = "192.168.1.65";  %"10.51.54.96"; 
rosinit(masterHostIP, 11311, "NodeHost", nodeHostIP)
%% ROS Class handle

% r will contains all publisher/subscriber/service/action/kinematic/tf info
disp("Creating Robot Handle...");
r = rosClassHandle_UR5e;

%% Options 

% Create global dictionary. Passed to all functions. Includes robot handle
keys   = ["debug", "rHandle"];
values = {      0, r};

% Instantiate the dictionary: values can be access via {}, i.e. optns{'key'}
disp("Creating dictionary...");    % THIS IS WHAT LINKS KEYS TO VALUES ---VERY IMPORTANT---
optns = dictionary(keys,values);  

%% 02 Reset the simulation
disp('Resetting the world...');

% **Complete Code**      % reset models through a gazebo service
resetWorld(optns); %NOTES:This is simply calling the function in the other script


%% 03 Get Model Poses

type = 'gazebo'; % gazebo, ptcloud, cam, manual
disp('Getting object goal pose(s)...')

% Get models from Gazebo
% **Complete Code**      % Get all model names via service
models = getModels(optns); %NOTE: remember not to just call this but to put
                           %it into the var models instead so it can be
                           %used later

% Number of models to pick (you can hard code or randomize)
n = length(models.ModelNames);



%% 04 Get the poses
% Create a loop to do:
%   1. Get model pose in homogenous transformation format
%   2. Display it on screen

%% 04 Get the poses

modelPoses = {};
for modelArrayPosition = 1:n
    model_name = models.ModelNames{modelArrayPosition};
    modelPoses{modelArrayPosition} = get_model_pose(model_name, optns);
end


% Set the rate at which this loop should run
rate = rosrate(10);

% For Gazebo retrieved poses
if strcmp(type,'gazebo')

    % For n models to pick up
    for i=1:n
        %% 05.1 Get Model Pose
        
        % 05.1.1 Get Model Name for each of the models
        % **Complete Code**
        model_name = models.ModelNames{i};

        % 05.1.2 Get Model pose
        fprintf('Picking up model: %s \n',model_name);
        pose = modelPoses{i};

        % Print the ROS position for the model
        fprintf("The pose position (xyz) is: [ %0.2f, %0.2f, %0.2f ]\n", ...
           pose.Pose.Position.X,pose.Pose.Position.Y, pose.Pose.Position.Z);
        % Print the ROS quaternion for the model xyzw
        fprintf("The pose quaternion (xyzw) is: [ %0.2f, %0.2f, %0.2f, %0.2f ]\n", ...
            pose.Pose.Orientation.X, ...
            pose.Pose.Orientation.Y, ...
            pose.Pose.Orientation.Z, ...
            pose.Pose.Orientation.W);
        % Create some space for next item.
        fprintf("\n\n")
    end
end