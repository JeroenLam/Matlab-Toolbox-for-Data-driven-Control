function [bool] = testSlater(X, U, Phi)
%TESTSLATER Summary of this function goes here
%   Detailed explanation goes here

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

