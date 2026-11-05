function resetWorld(optns)
%-------------------------------------------------------------------------- 
% resetWorld()
% Calls Gazebo service to reset the world
% Input: (dict) optns
% Output: None
%-------------------------------------------------------------------------- 
    disp('Resetting the world...');
    
    % TODO: 01 Get robot handle
    r = optns{'rHandle'};
    
    % TODO: 02 Create Empty Simulation message
    % **Complete Code**
    request = rosmessage(r.res_client); %NOTES:empty request as reset is a binary thing, no data to
                                        % pass through just a "do this for
                                        % me"

    % TODO: 03 Call reset service
    call(r.res_client, request); %NOTES: we still need 2 because you must prepare request 
                             % then send it
                                    
   
end