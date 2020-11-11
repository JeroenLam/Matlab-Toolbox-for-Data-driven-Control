function [bool] = ThetaValidity(Theta, Xmin, Xplus, printDebug)
%THETAVALIDITY verify that the provided theta for state feedback is valid
%for all neccesary constriants.
%  Input:  Theta      = theta matrix as in Theorem 17
%          Xmin       = Xmin data
%          Xplus      = Xplus data
%          printDebug = true for debug output, default false
%  Output: bool = true if the data is valid, false otherwise

    % Assign default values to parameters and output
    if nargin < 4
        printDebug = false;
    end
    bool = true;
    
    % Check if the provided data is symmetric
    if Xmin * Theta ~= (Xmin * Theta).'
        if printDebug
            disp("not symmetric");
            disp(Xmin * Theta - (Xmin * Theta).');
        end
        bool = false;
    end
    
    % Check if the provided parameters form a pos. def. matrix
    M = [ Xmin * Theta    Xplus * Theta ;
         (Xplus * Theta)'  Xmin * Theta ];
    
    if min(eig(M)) < 0
        if printDebug
            disp("not pos. def.");
            disp(eig(M));
        end
        bool = false;
    end
end

