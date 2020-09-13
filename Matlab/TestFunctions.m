function err = TestFunctions(struct)
%TESTFUNCTIONS Summary of this function goes here
%   Detailed explanation goes here
    % Test Identification
    if isIdentifiable(struct.U, struct.X)
        disp('    Identifiable');
        [A, B] = identification(struct.U, struct.X);
        if (A ~= struct.A)
            disp('  ! Error, A != As');
        elseif (B ~= struct.B)
            disp('  ! Error, B != Bs');
        end
    else
        disp('not Identifiable');
    end
    
    % Test Controllability
    if isControllable(struct.U, struct.X)
        disp('    Controllable');
    else
        disp('not Controllable');
    end
    
    % Test Stabilisability
    if isStabilisable(struct.U, struct.X)
        disp('    Stabilisable');
    else
        disp('not Stabilisable');
    end
        
end

