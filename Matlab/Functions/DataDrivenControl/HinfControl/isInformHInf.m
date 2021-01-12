function [bool, K, diagnostics, gamma, info] = isInformHInf(X, U, Phi, C, D, tolerance, options)
%ISINFORMHINF checks if the daat is informative for H_infinity control.
%  Input:  X         = matrix containing the measured state
%          U         = matrix containing the measured input
%          Phi       = matrix containing noise bound
%          C         = state output preformance matrix
%          D         = input output preformance matrix
%          tolerance = limit for singular to working presision (default: 1e-6)
%          options   = sdpsettings from YALMIP
%  Output: bool        = true if informative, false otherwise
%          K           = feedback gain A + BK if applicable, [] otherwise
%          diagnostics = diagnostics returned by YALMIP's optimize method
%          gamma       = value of gamma as found by the solver
%          info        = indicates if an error occured, solution might
%                        still be correct.
%                        1: No solution to the Slater condition
%                        2: Yalmip encountered a problem (see diagnostics)
%                        4: Matrix inequality 1 does not hold
%                        8: Matrix inequality 2 does not hold
%                       16: a !>= 0
%                       32: b !>  0
%                       64: Y !>  0
%                      128: gamma !> 0
%  Throws: InsufficientArguments  : Not enough input arguments.
%          NonNumericArgument     : Only provide numeric arguments!
%          InconsistentLengthData : The data is not the correst size, U should be 1 shorter than X.
%          EmptyStateData         : Provide a non empty state measurement matrix.


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
    
    % Defining Output parameters
    bool = 0;
    info = 0;
    gamma = NaN;
    K = [];
    
    % Test for the generelised Slater condition
    if ~testSlater(X, U, Phi)
        % The Slater condition failed
        info = info + 1;
        diagnostics = [];
        return;
    end
    
    % Defining variables
    Y = sdpvar(n);
    L = sdpvar(m,n);
    a = sdpvar(1);
    b = sdpvar(1);
    gamma = sdpvar(1); % is gamma^-2
    
    % Defining matrices for conditioning
    cond_matrix_1 = [ Y - b*eye(n) zeros(n, 2*n + m) (C*Y+D*L)';
                      zeros(n, 2*n + m) Y zeros(n,p);
                      zeros(m, 2*n + m) L zeros(m,p);
                      zeros(n, n) Y L' Y - gamma*eye(n) zeros(n,p); 
                      C*Y+D*L zeros(p, 2*n + m) eye(p)] -  a *...
                    [ eye(n)     Xplus;
                      zeros(n,n) -Xmin; 
                      zeros(m,n) -Umin;
                      zeros(n + p,n + T) ] * ...
                    Phi * ...
                    [ eye(n)     Xplus;
                      zeros(n,n) -Xmin; 
                      zeros(m,n) -Umin;
                      zeros(n + p,n + T) ]';
    cond_matrix_2 = Y - gamma*eye(n);
    
    C = [ cond_matrix_1 >= 0        , ...
          cond_matrix_2 >= tolerance, ...
          b >= tolerance            , ...
          a >= 0                    , ...
          Y >= tolerance];
      
    diagnostics = optimize(C, -gamma, options);
    
    % Check for problems with the solver
    if diagnostics.problem
        % The solver was not able to find a solution for the constraints
        info = info + 2;
    end
    
    % Check if the conditions are valid
    if min(eig(value(cond_matrix_1))) < 0
        % The matrix constraint 1 was not positive semi definite
        info = info + 4;
    end
    if min(eig(value(cond_matrix_2))) <= 0
        % The matrix constraint 2 was not positive definite
        info = info + 8;
    end
    if value(a) < 0
        % a >= 0 was not valid;
        info = info + 16;
    end
    if value(b) <= 0
        % b > 0 was not valid;
        info = info + 32;
    end 
    if min(eig(value(Y))) <= 0
        % Y > 0 was not valid;
        info = info + 64;
    end    
    if value(gamma) < 0
        % gamma !> 0
        info = info + 128;
    end
    
    
    
    K = value(L) / value(Y);
    bool = true; % Feels kind of pointless to add this since there is no good method for preemptive checking if the solution is correct.
    gamma = value(gamma);
end

