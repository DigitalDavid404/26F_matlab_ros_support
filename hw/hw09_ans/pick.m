function [traj_result,grip_result] = pick(strategy,objectData,optns,nm)
    %----------------------------------------------------------------------
    % pick 
    % Top-level function to executed a complete pick. 
    % 
    % 01 Calls moveTo to move to desired pose
    % 02 Calls doGrip to execute a grip
    %
    % Inputs
    % mat_R_T_M [4x4]: object pose wrt to base_link
    % mat_R_T_G  [4x4]: gripper pose wrt to base_link used as starting point in ctraj (optional)    
    % optns (dict): options 
    %
    % Outputs:
    % ret (bool): 0 indicates success, other failure.
    %
    % Note:
    % When new objects are added to the scene, new pick strategies will
    % need to be added to this file. That will require tinkering.
    %----------------------------------------------------------------------
     
    % Check type of objectData. If matrix, assign directly; otherwise
    % extract.
    if isequal(size(objectData), [4, 4]) && isnumeric(objectData)
        mat_R_T_M = objectData;
        
        % Simplistic label checker. Cannot tell vertical or horizontal.
        % Check for cans
        res = contains(nm,'can','IgnoreCase', true);
        if res
            label = "vCan";
        end

        res = contains(nm,'bottle','IgnoreCase', true);
        if res
            label = "vBottle";
        end      

        res = contains(nm,'pouch','IgnoreCase', true);
        if res
            label = "pouch";
        end             
    
    % Extract pose and label from object
    else
        label = objectData{1,1};         
        mat_R_T_M = objectData{1,2};         
    end
    % pause(2);

    %% 1) Determine z offset and grip distance required
    %   z offset includes offset for both the base and the gripper
        if strcmpi(string(label), "pouch")
            zOffset = 0.18;    % zOffset = 0.145;
            doGripValue = 0.59; %0.61
        
        elseif strcmpi(string(label), "vCan")  %%% COMPLETE
            zOffset = 0.18;     % zOffset = 0.15; 0.10;
            doGripValue = 0.23; % doGripValue = 0.23; 0.62;
        
        elseif strcmpi(string(label), "hCan") % COMPLETE
            zOffset = 0.15;
            doGripValue = 0.231;
        
        elseif strcmpi(string(label), "vBottle") %% COMP
            zOffset = 0.24;         % zOffset = 0.12;
            doGripValue = 0.5167;   % doGripValue = 0.36;     
        
        elseif strcmpi(string(label), "hBottle") % COMPLETE
            zOffset = 0.12;
            doGripValue = 0.21;

        elseif strcmpi(string(label), "marker")
            zOffset = -1; % TODO
            doGripValue = -1; % TODO
        
        elseif strcmpi(string(label), "spam")
            zOffset = -1; % TODO
            doGripValue = -1; % TODO
        else
            zOffset = optns{'z_offset'};
            doGripValue = 0.23;
        end

    %% 2) Move to desired location
        % Account for base offset + Hover over object
        if strcmp(strategy,'topdown')
            
            % Move to Lift (includes offset)
            liftHeight = 0.25 + zOffset;
            over_R_T_M = lift(mat_R_T_M, liftHeight);
            traj_result = moveTo(over_R_T_M,optns);

            % Move to Pick  
            pick_R_T_M = lift(mat_R_T_M, zOffset);
            traj_result = moveTo(pick_R_T_M, optns);     

        elseif strcmpi(strategy,'direct')
            pick_R_T_M = lift(mat_R_T_M, zOffset);
            traj_result = moveTo(mat_R_T_M,optns);
        end

        % Grip object
        [grip_result,grip_state] = doGrip('pick',optns,doGripValue); 
        grip_result = grip_result.ErrorCode;
   
end