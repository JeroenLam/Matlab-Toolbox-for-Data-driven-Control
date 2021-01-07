% Generate data
%U = [1 0 2 0 1 2 1 1 1 1 1 1 4 6 8 9 5 2 4 3 1 1 1 1 1 1 1 1 1 5 8 7 4 6 9 8 7; 
     0 1 0 2 0 0 0 1 1 1 2 2 4 6 8 3 1 5 7 9 1 1 1 1 1 1 1 1 5 7 9 6 4 8 6 8 4;
     0 1 1 0 1 0 2 0 2 0 1 1 2 3 0 2 1 3 0 1 1 1 1 1 1 1 1 1 2 3 7 9 6 5 4 3 2];
%B = [0 1 2;0 1 0];
%D = [0 0 0;0 0 0];

U = [1 2 0 1 0 -2 -1 0 1 2 0 10 -5];
B = [1 ; -1];
D = [0];

x0 = [0;0];
A = [0 1 ; -1 -1];%*0.5;
C = [1 0];




[U, X, Y] = generateData(A,B,x0,U,C,D);


% Find a controller using state data
[bool_dmf, K, L, M] = isInformDynamicMeasurementFeedback(X, U, Y);

% Find a controller without state data
[bool_si, X_bar, U_bar, Y_bar] = isInformStateIdentification(U, Y, 2)
[bool_dmf_bar, K_bar, L_bar, M_bar] = isInformDynamicMeasurementFeedback(X_bar, U_bar, Y_bar)

sys_cl = [ A    B*M;
          L*C K+L*D*M];
disp('eigenvalues Using full rank input')
eig(sys_cl)

sys_cl_bar = [ A    B*M_bar;
              L_bar*C K_bar+L_bar*D*M_bar];
disp('eigenvalues using state extimation')
eig(sys_cl_bar)


%%
% State estimation
n = size(A,1);
m = size(B,2);
k = rank(U);
l = size(C, 1);
T = size(U,2);

% Check if the input is of sufficient rank
disp('Is the rank of U sufficient');
disp(n < k && k < 0.5*T);

% Check if the Hankel matrices are of sufficient rank
H_2k_u = BlockHankel(U(:,1:2*k), U(:,2*k:end));
H_2k_y = BlockHankel(Y(:,1:2*k), Y(:,2*k:end));

disp('Rank of the stacked Hankel matrices')
rank([H_2k_u ; H_2k_y])

disp('Needed rank')
2*k*m+n

% If that is the case, we can find the row space of X_f
U_p = H_2k_u(1:end/2, :);
U_f = H_2k_u(end/2 + 1:end, :);
Y_p = H_2k_y(1:end/2, :);
Y_f = H_2k_y(end/2 + 1:end, :);


% - - Method 1 - - (From paper [48 thr4])
H1 = [Y_p ; U_p];
H2 = [Y_f ; U_f];
H = [H1 ; H2];
[U_h, S_h, ~] = svd(H);


s_11 = S_h(1:2 * m * k + n, 1:2 * m * k + n);
u_11 = U_h(1:(m + l) * k  , 1:2 * m * k + n);
u_12 = U_h(1:(m + l) * k  , 2 * m * k + n + 1:end);

[U_q, S_q, ~] = svd(u_12' * u_11 * s_11);
s_q_rank = rank(S_q);
u_q = U_q(:, 1:s_q_rank);

X_f = u_q' * u_12' * H1;



% - - Method 2 - - (Based on subspace intersection found on stackexchange)
% Find a basis for the row space
rs_p = colspace(sym([U_p ; Y_p]'));
rs_f = colspace(sym([U_f ; Y_f]'));

% Find the basis for the intersection
% https://math.stackexchange.com/questions/25371/how-to-find-basis-for-intersection-of-two-vector-spaces-in-mathbbrn
nullVec = null([rs_p -rs_f]);

X_f2 = [];
for idx = 1:size(nullVec,2)
    vec = nullVec(:,idx);
    vec_p = vec(1:size(rs_p));
    X_f2 = [X_f2 ; double(vec_p' * rs_p)];
end

ans_s_f = solve(X_bar_real(:,1:2) == S * X_f(:,1:2));
S_f = double([ans_s_f.s1_1 ans_s_f.s1_2 ; ans_s_f.s2_1 ans_s_f.s2_2]);

U_1 = U(:, k + 1:T - k);
Y_1 = Y(:, k + 1:T - k);
X_bar_real = X(:, k + 1:T - k + 1);


%X_bar = X_bar_real;
X_1 = X_f;
%X_bar = X_f2;

%[boolIdent, A, B, C, D] = isInformIdentification(X_bar, U_bar, Y_bar);

%%


[bool_bar, K_bar, L_bar, M_bar] = isInformDynamicMeasurementFeedback(X_bar, U_bar, Y_bar)

sys_cl_bar = [ A       B*M_bar;
               L_bar*C K_bar+L_bar*D*M_bar];
eig(sys_cl_bar)





[bool, X_bar, U_bar, Y_bar] = isInformStateIdentification(U, Y, 2)

% Since we have knowlage about C, can we use it to retreive the correct (or
% more correct) X_bar?, yes, yes we can

S = sym('s', [2 2]);
X_temp = X_bar(:,1:2);
Y_temp = Y_bar(:,1:2);
SX = S * X_temp;
ansS = solve(Y_temp(1,:) == SX(1,:));
S = [double(ansS.s1_1) double(ansS.s1_2) ; 0 1];
X_bar_s = S * X_bar;

[boolIdent, A, B, C, D] = isInformIdentification(X_bar_s, U_bar, Y_bar)