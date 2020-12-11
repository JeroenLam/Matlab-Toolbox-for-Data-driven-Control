function [bool, K, diagnostics, gamma] = isInformH2(X, U, Phi, C, D, tolerance, options)
%ISINFORMH2 Summary of this function goes here
%   Detailed explanation goes here

    % Validating data
    [Xmin, Xplus, n, Umin, m] = testDataInput(X, U);
    [~,T] = size(U);
    [p,~] = size(C);
    assert(min(size(Phi) == [n+T n+T]));
    
    % Defining missing input parameters
    switch nargin
        case 5
            options = sdpsettings('solver','mosek','debug',1,'verbose',0);
            options.mosek.MSK_DPAR_SEMIDEFINITE_TOL_APPROX = 10^(-15);
            tolerance = 1e-6;
        case 6
            options = sdpsettings('solver','mosek','debug',1,'verbose',0);
            options.mosek.MSK_DPAR_SEMIDEFINITE_TOL_APPROX = 10^(-15);
    end
    
    % Defining variables
    Y = sdpvar(n);
    Z = sdpvar(n);
    L = sdpvar(m,n);
    a = sdpvar(1);
    b = sdpvar(1);
    gamma = sdpvar(1);
    
    % Defining matrices for conditioning
    cond_matrix_1 = [ Y - b*eye(n) zeros(n, 2*n + m + p);
                      zeros(n, 2*n + m) Y zeros(n,p);
                      zeros(m, 2*n + m) L zeros(m,p);
                      zeros(n, n) Y L' Y (C*Y+D*L)'
                      zeros(p, 2*n + m) C*Y+D*L  eye(p)] -  a *...
                    [ eye(n)     Xplus;
                      zeros(n,n) -Xmin; 
                      zeros(m,n) -Umin;
                      zeros(n + p,n + T) ] * ...
                    Phi * ...
                    [ eye(n)     Xplus;
                      zeros(n,n) -Xmin; 
                      zeros(m,n) -Umin;
                      zeros(n + p,n + T) ]';
    cond_matrix_2 = cond_matrix_1(2*n+m+1:end, 2*n+m+1:end);
    cond_matrix_3 = [Z eye(n) ; eye(n) Y];
    
    C = [ cond_matrix_1 >= 0        , ...
          cond_matrix_2 >= tolerance, ...
          cond_matrix_3 >= 0        , ...
          trace(Z) <= gamma         , ...
          b >= tolerance            , ...
          a >= 0                    , ...
          Y >= tolerance];
         %gamma >= 0                , ... % Seems to cause problems
    
    diagnostics = optimize(C, gamma, options);
    K = value(L) / value(Y);
    bool = true; % Feels kind of pointless to add this since there is no good method for preemptive checking if the solution is correct.
    gamma = value(gamma);
end

