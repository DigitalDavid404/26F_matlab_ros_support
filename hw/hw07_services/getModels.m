function models = getModels(optns) %NOTE: notice how it returns models?
%-------------------------------------------------------------------------- 
% getModels
% This method will create a service client that talks to Gazebo's
% get_world_properties to get all model names.
%
% Inputs: (dict) optns
% Output: (gazebo_msgs/GetWorldPropertiesResponse cell): models
%--------------------------------------------------------------------------
    % TODO: 01 Get robot handle from dict optns
    r = optns{'rHandle'};

    
    % TODO: 02 Create model_client_msg 
request = rosmessage(r.get_models_client);
    
    % TODO: 03 Call client and save models
models = call(r.get_models_client, request); %NOTE: notice how it returns models?
                                                %hence why this call needs..
                                                %models = call(

end