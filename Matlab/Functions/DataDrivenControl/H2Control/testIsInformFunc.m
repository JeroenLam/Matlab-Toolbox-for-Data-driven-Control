%% Defining data
clear all
T = 750;   % Data samples      
n = 6;     % Dim A
m = 2;     % Dim B
p = 1;     % Dim C

epsilon = 0.005;

load('X');
load('U');

A = [-0.0226 -36.6170 -18.8970 -32.0900 3.2509 -0.7626 ;
      0.0001 -1.8997 0.9831 -0.0007 -0.1708 -0.0050 ; 
      0.0123 11.7200 -2.6316 0.0009 -31.6040 22.3960 ;
      0 0 1.0000 0 0 0 ;
      0 0 0 0 -30.0000 0 ;
      0 0 0 0 0 -30.0000];
B = [0 0 ; 0 0 ; 0 0 ; 0 0 ; 30 0 ; 0 30];
sys = ss(A,B, eye(6), zeros(6,2));

sys_d = c2d(sys,0.01);
A = sys_d.A;
B = sys_d.B;
C = [0 0 0 0 0 1];
D = [0 0];

Phi = [1.35 * T * epsilon^2 * eye(n) zeros(n,T);zeros(T,n) -eye(T)];

options = sdpsettings('solver','mosek','debug',1,'verbose',0);
options.mosek.MSK_DPAR_SEMIDEFINITE_TOL_APPROX = 10^(-15);
tol = 10^(-6);

%% Calling function
disp('Method Henk')
ans_henk = zeros(size(1:size(X,2)));
for idx = 3:size(X,2)
    [Xmin, Xplus, n, Umin, m] = testDataInput(X(:,1:idx), U(:,1:idx-1));
    T = idx-1;
    Phi = [1.35 * T * epsilon^2 * eye(n) zeros(n,T);zeros(T,n) -eye(T)];
    [~,K,~] = LMI_H2(Xmin,Xplus,Umin,Phi,C,D,eye(n),options,tol);
    A_K = A+B*K;
    C_K = C+D*K;
    if max(abs(eig(A_K))) < 1
        P = dlyap(A_K',C_K'*C_K);
        ans_henk(idx) = trace(P);   % value(gamma);
    end
end



disp('Method Jeroen')
ans_jeroen = zeros(size(1:size(X,2)));
for idx = 3:size(X,2)
    T = idx-1;
    Phi = [1.35 * T * epsilon^2 * eye(n) zeros(n,T);zeros(T,n) -eye(T)];
    [~, K, ~, ~] = isInformH2(X(:,1:T+1), U(:,1:T), Phi, C, D, tol, options);
    A_K = A+B*K;
    C_K = C+D*K;
    if max(abs(eig(A_K))) < 1
        P = dlyap(A_K',C_K'*C_K);
        ans_jeroen(idx) = trace(P);   % value(gamma);
    end
end

%% Plotting data
plot(ans_henk)
hold on
plot(ans_jeroen)
hold off

%% Finding best solution based on the system withour noise
d = n;
E = eye(n);

Y = sdpvar(n,n);
Z = sdpvar(d,d);
L = sdpvar(m,n);
gamma2 = sdpvar(1,1);
LMI = [Y >= tol*eye(n), ...
       gamma2 >= 0, ...
       [Y (A*Y+B*L)' (C*Y+D*L)';
        (A*Y+B*L) Y zeros(n,p);
        (C*Y+D*L) zeros(p,n) eye(p)] >= tol*eye(2*n+p), ...
       [Z E';E Y] >= zeros(n+d,n+d), ...
       trace(Z) <= gamma2];
optimize(LMI,gamma2,options);
gammabest = value(gamma2);
Lbest = value(L);
Ybest = value(Y);
Kbest = Lbest/Ybest;

