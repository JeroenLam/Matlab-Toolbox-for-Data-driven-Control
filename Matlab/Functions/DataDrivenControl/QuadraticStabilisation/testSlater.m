function [diagnostics, Z] = testSlater(X, U, W11, W12, W22)
%TESTSLATER Summary of this function goes here
%   Detailed explanation goes here

    % Constructing N
    [Xmin, Xplus, n, Umin, m] = testDataInput(X, U);
    N = [eye(n,n) Xplus; zeros(n,n) -Xmin; zeros(m,n) -Umin] * ...
        [W11 W12 ; W12' W22] * ...
        [eye(n,n) Xplus; zeros(n,n) -Xmin; zeros(m,n) -Umin]';

    % Checking generelised Slater condition (TODO: DOES NOT FINISH
    % CALCULATIONS)
    tolerance = 1e-10;
    options = sdpsettings('verbose',0,'debug',0);

    Z = sdpvar(n+m, n);
    C = [eye(n) Z'] * N * [eye(n) ; Z] >= tolerance;
    diagnostics = optimize(C, [], options);
    Z = value(Z);
end

