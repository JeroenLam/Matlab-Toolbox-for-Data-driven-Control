function [bool, K, L, M] = isInformDynamicMeasurementFeedback(X, U, Y, polesM, polesL)
%ISINFORMDYNAMICMEASUREMENTFEEDBACK checks if the data is informative for
%stabilisation by dynamic measurement feedback.
%  Input:  X      = matrix containing the measured state
%          U      = matrix containing the measured input
%          Y      = matrix containing the measured output
%          polesK = array containing proposed poles
%          polesL = array containing proposed poles
%  Output: bool  = true if informative, false otherwise
%          K/L/M = controller matrices
%  Throws: InsufficientArguments  : Not enough input arguments.
%          NonNumericArgument     : Only provide numeric arguments!
%          InconsistentLengthData : The data is not the correst size, U should be 1 shorter than X.
%          EmptyStateData         : Provide a non empty state measurement matrix.

    % Check data validity
    try
        [~, ~, n, Umin, m, ~] = testDataInput(X, U, Y);
    catch exception
        rethrow(exception)
    end
    
    if nargin == 3
        polesM = (0:n-1)/n;
        polesL = (0:n-1)/n;
    end
    
    % Case where the input has full row rank
    if rank(Umin) == m    
        % Check if the system is informative for system identification
        try
            [boolIdent, A, B, C, D] = isInformIdentification(X, U, Y);
        catch exception
            rethrow(exception)
        end

        % Predefine return variables
        bool = false;
        K = [];
        L = [];
        M = [];

        % Check if the system is stabilizable and detectable
        if boolIdent && isStabilizableD(A,B) && isDetectableD(C,A)
            bool = true;
            M = place(A, -B, polesM);
            L = place(A', C', polesL).';
            K = A + B*M - L*C - L*D*M;
        end
    % Case where the input does not have full row rank
    else
        % Define U_hat
        U_hat = double(colspace(sym(U'))');
        
        % Find an S 
        k = rank(Umin);
        S_var = sym('s', [m k]);
        S_ans = solve(Umin == S_var * U_hat);
        
        fn = fieldnames(S_ans);
        S = zeros(k, m);
        for idx = 1:numel(fn)
            S(idx) = S_ans.(fn{idx});
        end
        S = S';
        
        % Find the solution for the reduced problem
        [bool, K, L, M] = isInformDynamicMeasurementFeedback(X, U_hat, Y, polesM, polesL);
        M = S * M;
    end
end

