function [bool, K, diagnostics, info] = isInformLQR(X, U, Q, R, tolerance, options)
%ISINFORMLQR checks if the data is informative for LQR control. If that is
% the case the function will also return a corresponding stabilising 
% controller.
%  Input:  X         = matrix containing the measured state
%          U         = matrix containing the measured input
%          Q         = state cost matrix
%          R         = input cost matrix
%          tolerance = limit for singular to working presision (default: 1e-14)
%          options   = sdpsettings from YALMIP
%  Output: bool        = true if informative for deadbeat control, false otherwise
%          K           = the LQR controller A + BK if applicable, [] otherwise
%          diagnostics = diagnostics returned by YALMIP's optimize method
%          info        = indicates if an error occured, solution might
%                        still be correct.
%                        1 : Yalmip encountered a problem (see diagnostics)
%                        2 : Xmin * Theta was not symmetric
%                        4 : Matrix inequality does not hold
%                        8 : Umin * Theta ~= 0
%                        16: Q * Xplus * Theta ~= 0
%  Throws: InsufficientArguments  : Not enough input arguments.
%          NonNumericArgument     : Only provide numeric arguments!
%          InconsistentLengthData : The data is not the correst size, U should be 1 shorter than X.
%          EmptyStateData         : Provide a non empty state measurement matrix.

    % Check data validity
    try
        [Xmin, Xplus, n, Umin, m] = testDataInput(X, U);
    catch excepsion
        rethrow(excepsion)
    end
    
    % Prepare return variables
    bool = false;
    K = [];
    diagnostics = [];
    info = 0;
    
    
    % Define default solver and setting
    if nargin < 6
        options = sdpsettings('solver','mosek','debug',1,'verbose',0);
        options.mosek.MSK_DPAR_SEMIDEFINITE_TOL_APPROX = 10^(-15);
    end
    if nargin < 5
        tolerance = 1e-14;
    end
    
    % Based on Lemma 25
    % Case 1
    % The data is informative for system identification and the given
    % system is LQR solvable.
    if isInformIdentification(X, U)
        [A, B] = isInformIdentification(X, U);
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
             (Xplus * Theta)'  XminTheta      ] >= tolerance;
        C = C + [Umin * Theta == 0];
        C = C + [Q * Xplus * Theta == 0];
        
        % Solving the problem
        diagnostics = optimize(C, [], options);
        
        Theta = value(Theta);
        
        % Check if there was an error by Yalmip
        if diagnostics.problem
            info = info + 1;
        end

        % Check if the Xmin * Theta is symetric
        if Xmin * Theta ~= (Xmin * Theta).'
            info = info + 2;
        end
        
        % Check if the matrix inequality is satisfied
        M = [ Xmin * Theta    Xplus * Theta ;
             (Xplus * Theta)'  Xmin * Theta ];
        if min(eig(M)) < 0
            info = info + 4;
        end
        
        % Check Umin * Theta == 0
        if Umin * Theta ~= 0
            info = info + 8;
        end
        
        % Check Q * Xplus * Theta == 0
        if Q * Xplus * Theta ~= 0
            info = info + 16;
        end
        
        % return K
        bool = true;
        K = zeros(m, n);
    end
end

