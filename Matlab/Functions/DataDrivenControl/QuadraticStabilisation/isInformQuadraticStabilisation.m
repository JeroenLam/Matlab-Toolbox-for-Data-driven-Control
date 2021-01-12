function [bool, K, diagnostics, info] = isInformQuadraticStabilisation(X, U, Phi, tolerance, options)
%ISINFORMQUADRATICSTABILISATION checks if the daat is informative for
%quadratic stabilisation.
%  Input:  X         = matrix containing the measured state
%          U         = matrix containing the measured input
%          Phi       = matrix containing noise bound
%          tolerance = limit for singular to working presision (default: 1e-8)
%          options   = sdpsettings from YALMIP
%  Output: bool        = true if informative, false otherwise
%          K           = feedback gain A + BK if applicable, [] otherwise
%          diagnostics = diagnostics returned by YALMIP's optimize method
%          info        = indicates if an error occured, solution might
%                        still be correct.
%                        1: No solution to the Slater condition
%                        2: Yalmip encountered a problem (see diagnostics)
%                        4: Matrix inequality does not hold
%                        8: a !>= 0
%                       16: b !>  0
%                       32: P not symmetric positive definite
%  Throws: InsufficientArguments  : Not enough input arguments.
%          NonNumericArgument     : Only provide numeric arguments!
%          InconsistentLengthData : The data is not the correst size, U should be 1 shorter than X.
%          EmptyStateData         : Provide a non empty state measurement matrix.

    % Validating data
    [Xmin, Xplus, n, Umin, m] = testDataInput(X, U);
    T = size(U,2);
    assert(min(size(Phi) == [n+T n+T]));
    
    % Defining missing input parameters
    switch nargin
        case 3
            tolerance = 1e-12;
            options = sdpsettings('verbose',0,'debug',0);
        case 4
            options = sdpsettings('verbose',0,'debug',0);
    end
    
    % Defining Output parameters
    bool = 0;
    info = 0;
    K = [];
    
    % Test for the generelised Slater condition
    if ~testSlater(X, U, Phi)
        % The Slater condition failed
        info = info + 1;
        diagnostics = [];
        return;
    end
    
    % Find P, L, a, b such that the condition of theorem 13 are satisfied
    P = sdpvar(n);
    L = sdpvar(m,n);
    a = sdpvar(1);
    b = sdpvar(1);
    
    condition_matrix = [ P-b*eye(n) zeros(n,2*n + m);
                         zeros(n,n) -P -L' zeros(n,n);
                         zeros(m,n) -L  zeros(m,m) L;
                         zeros(n,2*n)  L'  P ] -  a *...
                         [ eye(n)     Xplus;
                           zeros(n,n) -Xmin; 
                           zeros(m,n) -Umin;
                           zeros(n,n + T) ] * ...
                         Phi * ...
                         [ eye(n)     Xplus;
                           zeros(n,n) -Xmin; 
                           zeros(m,n) -Umin;
                           zeros(n,n + T) ]';
    % Defining the constraints
    C = [P >= tolerance * 1e-2, ...
         a >= 0, ...
         b >= tolerance * 1e-2, ...
         condition_matrix >= 0];

    % Finding a solution given the constraints
    diagnostics = optimize(C, [], options);

    % Check for problems with the solver
    if diagnostics.problem
        % The solver was not able to find a solution for the constraints
        info = info + 2;
    end
    
    % Check if the matrix condition is valid
    if min(eig(value(condition_matrix))) < 0
        % The matrix constraint was not positive semi definite
        info = info + 4;
    end
    
    K = value(L) / value(P);
    
    % Verify the solution is valid given the constraints
    if value(a) >= 0 && value(b) > 0
        bool = true;
        K = value(L) / value(P);
    else
        if value(a) < 0
            % a >= 0 was not valid;
            info = info + 8;
        end
        if value(b) <= 0
            % b > 0 was not valid;
            info = info + 16;
        end
    end
    
    try chol(value(P));
    catch ME
        % P is not symmetric positive definite
        info = info + 32;
    end
end

