function [bool, K] = isInformLQR_Yalmip(X, U, Q, R, tolerance, options)
%ISINFORMLQR_YALMIP Summary of this function goes here
%   Detailed explanation goes here

    % Check data validity
    [Xmin, Xplus, n, Umin] = testDataInput(X, U);
    
    % Prepare return variables
    bool = false;
    K = [];
    
    % Define default solver and setting
    if nargin < 4
        options = sdpsettings('verbose',0,'debug',0);
    elseif nargin < 4
        tolerance = 1e-8;
    end
    
    % Based on Lemma 25
    % Case 1
    % The data is informative for system identification and the given
    % system is LQR solvable.
    if isIdentifiable(X, U)
        [A, B] = identification(X, U);
        [bool, K] = isLQRSolvable(A, B, Q, R);
        return;
    % Case 2
    % All systems describing the data have the same A matrix. Moreover A is
    % stable and QA = 0. The optimal feedback gain is given by K = 0;
    else
        % Define variable (XminTheta is symmetric by construction)
        XminTheta = sdpvar(n);
        Theta = pinv(Xmin) * XminTheta;
        
        % Add constraint
        C = [ XminTheta        Xplus * Theta ;
             (Xplus * Theta).' XminTheta      ] >= tolerance;
        C = C + [Umin * Theta == 0];
        C = C + [Q * Xplus * Theta == 0];
        
        % Solving the problem
        diagnostics = optimize(C, [], options);
        
        % If no problems occured, return K
        if not(diagnostics.problem)
            bool = true;
            K = zeros(m, n);
            % TODO Calculate K based on Data
        end
    end
end

