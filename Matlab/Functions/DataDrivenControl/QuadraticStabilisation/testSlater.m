function [bool] = testSlater(X, U, Phi)
%TESTSLATER checks if the generelised Slater condition holds.
%  Input:  X         = matrix containing the measured state
%          U         = matrix containing the measured input
%          Phi       = matrix containing noise bound
%  Output: bool = true if Slater condition holds, false otherwise
%  Throws: InsufficientArguments  : Not enough input arguments.
%          NonNumericArgument     : Only provide numeric arguments!
%          InconsistentLengthData : The data is not the correst size, U should be 1 shorter than X.
%          EmptyStateData         : Provide a non empty state measurement matrix.

    % Constructing N
    [Xmin, Xplus, n, Umin, m] = testDataInput(X, U);
    N = [eye(n,n) Xplus; zeros(n,n) -Xmin; zeros(m,n) -Umin] * ...
        Phi * ...
        [eye(n,n) Xplus; zeros(n,n) -Xmin; zeros(m,n) -Umin]';
    
    bool = false;
    
    % Check if we have enough positive eigenvalues
    if sum(eig(N) > 0) >= n
        bool = true;
        return
    end
end

