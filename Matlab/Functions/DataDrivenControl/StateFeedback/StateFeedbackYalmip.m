function [bool, K, diagnostics] = StateFeedbackYalmip(X, U, tolerance, options)
%STATEFEEDBACKYALMIP Checks if the data is informative for state feedback
%using YALMIP and if that is the case it will return the K matrix. It will
%also return the YALMIP diagnostics. The controller is of the form A + BK.
%  Input:  X         = matrix containing the measured state
%          U         = matrix containing the measured input
%          tolerance = limit for singular to working presision (default: 1e-14)
%          options   = sdpsettings from YALMIP
%  Output: bool        = true if the controller exists, false otherwise
%          K           = state feedback controller A + BK
%          diagnostics = diagnostics returned by YALMIP's optimize method
%  Throws: The methods throws if the data is not of the correct format

    % Check data validity
    [Xmin, Xplus, n, Umin] = testDataInput(X, U);
    
    % Prepare return variables
    bool = false;
    K = [];
    
    % Define default solver and setting
    if nargin < 4
        options = sdpsettings('verbose',0,'debug',0);
    end
    if nargin < 3
        tolerance = 1e-14;
    end
    
    % Define variable (XminTheta is symmetric by construction)
    XminTheta = sdpvar(n);
    Theta = pinv(Xmin) * XminTheta;

    % Add constraint
    C = [[XminTheta Xplus*Theta ; (Xplus*Theta).' XminTheta] >= tolerance];

    % Solving the problem
    diagnostics = optimize(C, [], options);
    
    % DEBUG REMOVE LATER ON
    ThetaValidity(value(Theta), Xmin, Xplus);
    
    % If no problems occured, return K
    if not(diagnostics.problem)
        bool = true;
        K = Umin * value(Theta) * inv( Xmin * value(Theta) );
    end
end

