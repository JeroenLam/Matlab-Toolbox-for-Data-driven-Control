function [bool,K, diagnostics, diagnostics_slater] = isInformQuadraticStabilisation(X, U, W11, W12, W22)
%ISINFORMQUADRATICSTABILISATION Summary of this function goes here
%   Detailed explanation goes here

    % Validating data
    [Xmin, Xplus, n, Umin, m] = testDataInput(X, U);
    T = size(U,2);
    assert(min(size(W11) == [n n]));
    assert(min(size(W12) == [n T]));
    assert(min(size(W22) == [T T]));
    
    % Test for the generelised Slater condition
    [diagnostics_slater, ~] = testSlater(X, U, W11, W12, W22);
    if diagnostics_slater.problem
        disp('Error finding a solution to the generelised Slater condition!');
    end
    
    % Find P, L, a, b such that the condition of theorem 13 are satisfied
    P = sdpvar(n);
    L = sdpvar(m,n);
    a = sdpvar(1);
    b = sdpvar(1);
    
    tolerance = 1e-10;
    options = sdpsettings('verbose',0,'debug',0);
    
    nn = zeros(n,n);
    nm = zeros(n,m);
    mn = zeros(m,n);
    mm = zeros(m,m);
    C = [P >= tolerance, ...
         a >= 0, ...
         b >= tolerance, ...
         [P-b*eye(n) nn  nm nn;
             nn      -P -L' nn;
             mn      -L  mm  L;
             nn      nn  L'  P ] -  a *...
         [ eye(n)    Xplus;
           nn        -Xmin; 
           mn        -Umin;
           zeros(n,n + T) ] * ...
         [ W11 W12;
           W12' W22 ] * ...
         [ eye(n)    Xplus;
           nn        -Xmin; 
           mn        -Umin;
           zeros(n,n + T) ]' >= 0];

    diagnostics = optimize(C, [], options);
    
    % Check for problems with the solver
    if diagnostics.problem
        disp('The solver was not able to find a solution for the constraints');
        K = [];
        bool = false;
        return;
    end
    
    % Verify the solution is valid given the constraints
    try chol(value(P));
        if value(a) >= 0 && value(b) > -tolerance
            bool = true;
            K = value(L) / value(P);
        else
            disp('a >= 0 or b > 0 was not valid')
            fprintf('a : %d \n', value(a));
            fprintf('b : %d \n', value(b));
        end
    catch ME
        disp('P is not symmetric positive definite')
    end
end

