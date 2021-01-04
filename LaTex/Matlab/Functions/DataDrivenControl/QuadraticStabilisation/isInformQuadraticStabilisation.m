function [bool, K, diagnostics, info] = isInformQuadraticStabilisation(X, U, Phi, tolerance, options)
%ISINFORMQUADRATICSTABILISATION Summary of this function goes here
%   Detailed explanation goes here

    % Validating data
    [Xmin, Xplus, n, Umin, m] = testDataInput(X, U);
    T = size(U,2);
    assert(min(size(Phi) == [n+T n+T]));
    
    % Defining missing input parameters
    switch nargin
        case 3
            tolerance = 1e-8;
            options = sdpsettings('verbose',0,'debug',0);
        case 4
            options = sdpsettings('verbose',0,'debug',0);
    end
    
    bool = 0;
    info = 0;
    K = [];
    
    % Test for the generelised Slater condition
    if ~testSlater(X, U, Phi)
        %info = 'Error finding a solution to the generelised Slater condition!';
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
        %info = 'The solver was not able to find a solution for the constraints';
        info = info + 2;
        %disp(diagnostics.info)
        %return;
    end
    
    % Check if the matrix condition is valid
    if min(eig(value(condition_matrix))) < 0
        %info = 'The matrix constraint was not positive semi definite';
        fprintf('min(eig): %d\n', min(eig(value(condition_matrix))));
        info = info + 4;
        %return;
    end
    
    K = value(L) / value(P);
    
    % Verify the solution is valid given the constraints
    if value(a) >= 0 && value(b) > 0
        bool = 1;
        K = value(L) / value(P);
        %info = 'no problems';
    else
        if value(a) < 0
            fprintf('a: %d\n', value(a));
            info = info + 8;
        end
        if value(b) <= 0
            fprintf('b: %d\n', value(b));
            info = info + 16;
        end
            %info = 'a >= 0 or b > 0 was not valid';
            %return;
    end
    
    try chol(value(P));
    catch ME
        %info = 'P is not symmetric positive definite';
        info = info + 32;
        %return;
    end
end

