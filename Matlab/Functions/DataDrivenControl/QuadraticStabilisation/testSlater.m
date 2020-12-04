function [bool] = testSlater(X, U, W11, W12, W22)
%TESTSLATER Summary of this function goes here
%   Detailed explanation goes here

    % Constructing N
    [Xmin, Xplus, n, Umin, m] = testDataInput(X, U);
    N = [eye(n,n) Xplus; zeros(n,n) -Xmin; zeros(m,n) -Umin] * ...
        [W11 W12 ; W12' W22] * ...
        [eye(n,n) Xplus; zeros(n,n) -Xmin; zeros(m,n) -Umin]';
    
    bool = false;
    
    % Check if we have enough positive eigenvalues
    if sum(eig(N) > 0) >= n
        bool = true;
        return
    end
end

