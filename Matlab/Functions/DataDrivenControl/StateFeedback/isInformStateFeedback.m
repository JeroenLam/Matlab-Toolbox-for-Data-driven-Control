function [bool, K, diagnostics, info] = isInformStateFeedback(X, U, tolerance, options)
%STATEFEEDBACKYALMIP Checks if the data is informative for state feedback
%using YALMIP and if that is the case it will return the K matrix. It will
%also return the YALMIP diagnostics. The controller is of the form A + BK.
%  Input:  X         = matrix containing the measured state
%          U         = matrix containing the measured input
%          tolerance = limit for singular to working presision (default: 1e-14)
%          options   = sdpsettings from YALMIP
%  Output: bool        = true if the controller exists, false otherwise
%          K           = state feedback controller A + BK if applicable, [] otherwise
%          diagnostics = diagnostics returned by YALMIP's optimize method
%          info        = indicates if an error occured, solution might
%                        still be correct.
%                        1: Yalmip encountered a problem (see diagnostics)
%                        2: Xmin * Theta was not symmetric
%                        4: Matrix inequality does not hold
%  Note: If info is not 0 there is no guarante that the provided K is a
%  valid solution, however in testing we found that a lot of the time a
%  valid solution is still found.
%  Throws: InsufficientArguments  : Not enough input arguments.
%          NonNumericArgument     : Only provide numeric arguments!
%          InconsistentLengthData : The data is not the correst size, U should be 1 shorter than X.
%          EmptyStateData         : Provide a non empty state measurement matrix.

    % Check data validity
    try
        [Xmin, Xplus, n, Umin] = testDataInput(X, U);
        [~,T] = size(Xmin);
    catch exception
        rethrow(exception)
    end
    
    % Prepare return variables
    bool = false;
    K = [];
    info = 0;
    
    % Define default solver and setting
    if nargin < 4
        options = sdpsettings('solver','mosek','debug',1,'verbose',0);
        options.mosek.MSK_DPAR_SEMIDEFINITE_TOL_APPROX = 10^(-15);
    end
    if nargin < 3
        tolerance = 1e-14;
    end
    
    % Check pseudo inverse before hand
    if rank(Xmin) == n
        if isStableD(Xplus * pinv(Xmin))
            bool = 1;
            K = Umin * pinv(Xmin);
            diagnostics = [];
            return
        end
    end
    
    % Define variables (XminTheta is symmetric by construction)
    Theta = sdpvar(T, n);
    P = sdpvar(n);
    
    % Add constraint
    C = [[P Xplus*Theta ; (Xplus*Theta)' P] >= tolerance*eye(2*n), P == Xmin * Theta];

    % Solving the problem
    diagnostics = optimize(C, [], options);
    
    Theta = value(Theta);
    
    % Check if there was an error by Yalmip
    if diagnostics.problem
        info = info + 1;
    end
    
    % Check if the Xmin * Theta is symetric
    if Xmin * Theta ~= (Xmin * Theta)'
        info = info + 2;
    end
    
    % Check if the matrix inequality is satisfied
    M = [ Xmin * Theta    Xplus * Theta ;
         (Xplus * Theta)'  Xmin * Theta ];
    if min(eig(M)) < 0
        info = info + 4;
    end
    
    % Return the controller if it does not contain inf or NaN
    K = (Umin * Theta) / ( Xmin * Theta );
    if ~sum(sum(isnan(K) + isinf(K)))
        if info == 0
            bool = true;
        end
    end 
end





















