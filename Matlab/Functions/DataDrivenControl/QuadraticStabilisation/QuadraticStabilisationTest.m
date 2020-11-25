% System matrices
%A = [ 0 1 ; -1 -1]; % Stable
A = [ 0 0.75 ; 3 0 ];  % Unstable

B = [ 0 ; 1];

%Input and i.c.
U = [3 1 0 2];
x0 = [0;0];

% Defining constants and allocating memory
n  = size(A,1);
samples = size(U,2);

% Defining the noice we will use
%W = 0.1*(rand([n samples]) - 0.5);
W = [-0.0061    0.0266   -0.0313   -0.0054;
     -0.0118    0.0295   -0.0010    0.0146];

% Generating non noisy data samples
[U, X]   = generateData(A, B, x0, U);
[U, X_n] = generateData(A, B, x0, U, [], [], W);

% Finding the noice matrix (Seems to work for all W generated above)
W11 = 0.1*eye(n); % n*n
W12 = zeros(n,samples); % n*T
W22 = -0.1*eye(samples); % T*T
eig([eye(n,n) ; W']' * [W11 W12 ; W12' W22] * [eye(n,n) ; W']);


[b  ,K  , diag  , diag_slater  ] = isInformQuadraticStabilisation(X  , U, W11, W12, W22);
[b_n,K_n, diag_n, diag_slater_n] = isInformQuadraticStabilisation(X_n, U, W11, W12, W22);






















