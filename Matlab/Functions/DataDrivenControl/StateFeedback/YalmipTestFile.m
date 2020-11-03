clear all
% Data
A  = [ 1.5 0 ; 1 0.5];
B  = [1 ; 0];
x0 = [1 ; 0];
U  = [ -1 -1 ];
[U, X] = generateData(A, B, x0, U);
[Xmin, Xplus, n, Umin] = testDataInput(X, U);

[bool, K, diagnostics] = StateFeedbackYalmip(X, U)
[bool, K] = StateFeedbackCVX(X, U)

disp("Yalmip");
StateFeedbackYalmip(X, U)
disp("CVX");
[bool, K] = StateFeedbackCVX(X, U)

% Solver Settings
%options1 = sdpsettings('solver','mosek','verbose',0,'debug',0);
%options2 = sdpsettings('solver','sdpt3','verbose',0,'debug',0);
%[bool, K, diagnostics] = StateFeedbackYalmip(X, U, options1)
%[bool, K, diagnostics] = StateFeedbackYalmip(X, U, options2)