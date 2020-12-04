% System matrices
%A = [ 0 1 ; -1 -1]; % Stable
%A = [ 0 0.75 ; 3 0 ];  % Unstable
A = [1 -0.374 -0.19 -0.321 0.056 -0.026; 
     0 0.982 0.01 0 0.003 0.001; 
     0 0.115 0.975 0 -0.269 0.191;
     0 0.001 0.01 1 -0.001 0.001;
     0 0 0 0 0.741 0;
     0 0 0 0 0 0.741];
    

B = [ 0.007 0 -0.043 0 0.259 0 ; -0.003 0 0.03 0 0 0.259]';

%Input and i.c.
T = 100;
U = 0.5*rand([size(B,2) T]);
x0 = rand([size(A,1) 1]);

% Defining constants and allocating memory
n  = size(A,1);

% Defining the noice we will use
W = 0.05*(rand([n T]) - 0.5);

% Generating non noisy data samples
[U, X]   = generateData(A, B, x0, U);
[U, X_n] = generateData(A, B, x0, U, [], [], W);

% Finding the noice matrix (Seems to work for all W generated above)
W11 = 0.1*eye(n); % n*n
W12 = zeros(n,T); % n*T
W22 = -0.1*eye(T); % T*T
eig([eye(n,n) ; W']' * [W11 W12 ; W12' W22] * [eye(n,n) ; W']);

C = [0 0 0 0 0 1];
D = [0 0];
tolerance = 1e-10;
options = sdpsettings('verbose',0,'debug',0);

% (X, U, W11, W12, W22, C, D, gamma, tolerance, options)
% ***************************************
%          Code for H2 control
% ***************************************

    % Validating data
    [Xmin, Xplus, n, Umin, m] = testDataInput(X, U);
    T = size(U,2);
    assert(min(size(W11) == [n n]));
    assert(min(size(W12) == [n T]));
    assert(min(size(W22) == [T T]));
    assert(size(C,1) == size(D,1));
    assert(size(C,2) == n && size(D,2) == m);
    p = size(C,1);
    
    % Test for the generelised Slater condition
    if ~testSlater(X, U, W11, W12, W22, tolerance, options)
        disp('Error finding a solution to the generelised Slater condition!');
    end
    
    % Find Y, Z, L, a, b such that the conditions of theorem 16 are
    % satisfied:
    Y = sdpvar(n);
    Z = sdpvar(n);
    L = sdpvar(m,n);
    a = sdpvar(1);
    b = sdpvar(1);
    gamma2 = sdpvar(1);
      
    cond_matrix_1 = [Y - b*eye(n) zeros(n, 2*n + m + p);
                     zeros(n, 2*n + m) Y zeros(n,p);
                     zeros(m, 2*n + m) L zeros(m,p);
                     zeros(n, n) Y L' Y (C*Y+D*L)'
                     zeros(p, 2*n + m) C*Y+D*L  eye(p)] -  a *...
                     [ eye(n)    Xplus;
                       nn        -Xmin; 
                       mn        -Umin;
                       zeros(n + p,n + T) ] * ...
                     [ W11 W12;
                       W12' W22 ] * ...
                     [ eye(n)    Xplus;
                       nn        -Xmin; 
                       mn        -Umin;
                       zeros(n + p,n + T) ]';

    cond_matrix_2 = cond_matrix_1(2*n+m+1:end, 2*n+m+1:end);
    cond_matrix_3 = [Z eye(n) ; eye(n) Y];
    
    % Defining the constraints
    C = [Y >= tolerance            , ...
         a >= 0                    , ...
         b >= tolerance            , ...
         cond_matrix_1 >= 0        , ...
         cond_matrix_2 >= tolerance, ...
         cond_matrix_3 >= 0        , ...
         trace(Z) <= gamma2];
    
    % Finding a solution given the constraints
    diagnostics = optimize(C, abs(gamma - 1), options)
    %abs(gamma - 1)
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    