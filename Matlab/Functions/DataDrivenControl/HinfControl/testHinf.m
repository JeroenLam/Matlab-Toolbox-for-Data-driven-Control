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
%C = [1 1 1 1 1 1];
%D = [0 0];


Phi = [1.35 * T * epsilon^2 * eye(n) zeros(n,T);zeros(T,n) -eye(T)];

options = sdpsettings('solver','mosek','debug',1,'verbose',0);
options.mosek.MSK_DPAR_SEMIDEFINITE_TOL_APPROX = 10^(-15);
tol = 10^(-6);

%% Calling function
poolobj = parpool(4);

T = 750;
step = 1;

eigenvaluesHI = zeros(n,size(1:step:T,2));
eigenvaluesH2 = zeros(n,size(1:step:T,2));
gamma_h2      = zeros(1,size(1:step:T,2));
gamma_hi      = zeros(1,size(1:step:T,2));

parfor idx = 1:step:T
    Phi = [1.35 * idx * epsilon^2 * eye(n) zeros(n,idx);zeros(idx,n) -eye(idx)];
    [~, K_hi, ~, ~] = isInformHInf(X(:,1:idx+1), U(:,1:idx), Phi, C, D, tol, options);
    [~, K_h2, ~, ~] = isInformH2(X(:,1:idx+1), U(:,1:idx), Phi, C, D, tol, options);
    %if isStableD(A+B*K_hi)
        %fprintf('H_inf: %d\n',idx);
        eigenvaluesHI(:,idx) = abs(eig(A+B*K_hi))
        sys_temp = ss(A+B*K_hi, zeros(6,1), eye(6), [], 0.01)
        gamma_hi(idx) = hinfnorm(sys_temp)
    %end
    if isStableD(A+B*K_h2)
        %fprintf('H_2: %d\n',idx);
        A_K = A+B*K_h2;
        C_K = C+D*K_h2;
        eigenvaluesH2(:,idx) = abs(eig(A_K));
        if max(abs(eig(A_K))) < 1
            P = dlyap(A_K',C_K'*C_K);
            gamma_h2(idx) = trace(P);   % value(gamma);
        end
    end
end

subplot(2,2,1);
plot(eigenvaluesH2');
title('H_2 eigenvalues')
xlim([0,750])

subplot(2,2,2);
plot(eigenvaluesHI');
title('H_{inf} eigenvalues')
xlim([0,750])

subplot(2,2,3);
plot(gamma_h2);
title('gamma H_2')
axis([0 750 0 25])

subplot(2,2,4);
plot(gamma_hi)
title('Gamma H_{inf}')
ylim([0,25])
xlim([0,750])
