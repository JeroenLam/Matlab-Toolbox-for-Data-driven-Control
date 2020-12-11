%% add paths of yalmip and mosek, set options of the solver

addpath(genpath('X:\My Documents\Code\Yalmip\YALMIP-master'))
addpath('C:\Program Files\Mosek\9.1\toolbox\R2015a')
options = sdpsettings('solver','mosek','debug',1,'verbose',0);
options.mosek.MSK_DPAR_SEMIDEFINITE_TOL_APPROX = 10^(-15);

%options = sdpsettings('solver','sedumi','debug',1,'verbose',0);
%options.sedumi.eps = 10^(-15);

tol = 10^(-6);

%% system matrices 

Acont = [-0.0226 -36.6170 -18.8970 -32.0900 3.2509 -0.7626;
         0.0001 -1.8997 0.9831 -0.0007 -0.1708 -0.0050;
         0.0123 11.7200 -2.6316 0.0009 -31.6040 22.3960;
         0 0 1 0 0 0;
         0 0 0 0 -30 0;
         0 0 0 0 0 -30];
Bcont = [0 0;
         0 0;
         0 0;
         0 0;
         30 0;
         0 30];
n = 6;
m = 2;
sampling = 0.01;

A = expm(Acont*sampling);
stepsize = 0.001;
integral = zeros(n,n);
for i = 0:stepsize:sampling
    if i == 0 || i == sampling
        integral = integral + .5*expm(Acont*(sampling-i));
    else
        integral = integral + expm(Acont*(sampling-i));
    end
end
integral = integral*stepsize;
B = integral*Bcont;
E = eye(n);
C = [0 0 0 0 0 1];
[~,d] = size(E);
[p,~] = size(C);
D = zeros(p,m);

%%
Y = sdpvar(n,n);
Z = sdpvar(d,d);
L = sdpvar(m,n);
gamma2 = sdpvar(1,1);
LMI = [Y>=tol*eye(n),gamma2>=0,[Y (A*Y+B*L)' (C*Y+D*L)';(A*Y+B*L) Y zeros(n,p);(C*Y+D*L) zeros(p,n) eye(p)]>=tol*eye(2*n+p),[Z E';E Y]>=zeros(n+d,n+d),trace(Z)<=gamma2];
optimize(LMI,gamma2,options);
gammabest = value(gamma2);
Lbest = value(L);
Ybest = value(Y);
Kbest = Lbest/Ybest;
display(gammabest);

%% Generation of data 
T = 750;             
epsilon = 0.005;

% W = epsilon*randn(n,T);
% 
% % initial state and inputs, drawn randomly from Gaussian distribution
% x = randn(n,1);
% X = [x zeros(n,T)];
% U = randn(m,T);
% 
% % generate the states 
% for i = 1:T
%     X(:,i+1) = A*X(:,i)+B*U(:,i)+E*W(:,i);
% end

% load data set -generated in the above way- that was used in the paper
load('X');
load('U');
load('W');

% matrices X_+ and X_- required for the design
Xp = X(:,2:end);
Xm = X(:,1:end-1);

%% LMI formulation van Waarde et al. 
sampling = 50;
NORMS = 1000*ones(1,T/sampling);
factor = 1.35;

for i = 1:(T/sampling)
    time = sampling*i;
    Xm_part = Xm(:,1:time);
    Xp_part = Xp(:,1:time);
    U_part  = U(:,1:time);
    W_part  = W(:,1:time);
    Phi_part = [factor*epsilon^2*eye(n)*time zeros(n,time);zeros(time,n) -eye(time)];
    [~,K] = LMI_H2(Xm_part,Xp_part,U_part,Phi_part,C,D,E,options,tol);  
    A_K = A+B*K;
    C_K = C+D*K;
    %P = sdpvar(n,n);
    %gamma = sdpvar(1,1);
    %LMI = [P-A_K'*P*A_K-C_K'*C_K>=tol*eye(n),trace(E'*P*E)<=gamma,P>=tol*eye(n),gamma>=0];
    %optimize(LMI,gamma,options);
    P = dlyap(A_K',C_K'*C_K);
    if max(abs(eig(A_K))) < 1
    NORMS(1,i) = trace(E'*P*E);   % value(gamma);
    end
end
figure;
plot(linspace(sampling,T,T/sampling),NORMS)
ylim([0,25])
xlim([0,750])
hold on
plot(linspace(0,T,1+T/sampling),gammabest*ones(1,1+T/sampling))
xlabel('number of samples','FontSize',12)
ylabel('performance \gamma^2_s','FontSize',12)
h = legend('data-driven solution','optimal performance');
set(h,'FontSize',12);


