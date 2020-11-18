X = [];
U = [1 0 2 0 1 2 1 1 1 1 1 1 4 6 8 9 5 2 4 3 1 1 1 1 1 1 1 1 1 5 8 7 4 6 9 8 7; 
     0 1 0 2 0 0 0 1 1 1 2 2 4 6 8 3 1 5 7 9 1 1 1 1 1 1 1 1 5 7 9 6 4 8 6 8 4;
     0 1 1 0 1 0 2 0 2 0 1 1 2 3 0 2 1 3 0 1 1 1 1 1 1 1 1 1 2 3 7 9 6 5 4 3 2];
Y = [];

x0 = [0;0];

A = [0 1 ; -1 -1]*0.5;
B = [0 1 2;0 1 0];
C = [1 0; 0 0];
D = [0 0 0;0 0 0];

sys_d = ss(A,B,C,D,1);

[U, X, Y] = generateData(A,B,x0,U,C,D);

[bool, K, L, M] = isInformDynamicMeasurementFeedback(X, U, Y);



sys_cl = [ A    B*M;
          L*C K+L*D*M];
eig(sys_cl);

% State extimation
n = size(A,1);
m = size(B,2);
k = rank(U);
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

% Find a basis for the row space
rs_p = colspace(sym([U_p ; Y_p]'))';
rs_f = colspace(sym([U_f ; Y_f]'))';

% Find the basis for the intersection
% https://math.stackexchange.com/questions/25371/how-to-find-basis-for-intersection-of-two-vector-spaces-in-mathbbrn
nullVec = null([rs_p' -rs_f']);

X_f = [];
for idx = 1:size(nullVec,2)
    vec = nullVec(:,idx);
    vec_p = vec(1:size(rs_p));
    X_f = [X_f ; double(vec_p' * rs_p)];
end


U_bar = U(:, k:T-k-1);
Y_bar = Y(:, k:T-k-1);
X_bar_real = X(:, k:T-k);

% I can not find an S such that the basis is mapped to the data
S = eye(2);

X_bar = S * X_f;

[boolIdent, A, B, C, D] = isInformIdentification(X_bar, U_bar, Y_bar)















