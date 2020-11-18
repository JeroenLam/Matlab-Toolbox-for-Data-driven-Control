A = [0 1 0 ; 2 0 0 ; 0 0 1];
B = [1 0 ; 0 1; 1 1];

n = size(A,2);
m = size(B,2);

poles = [0 0 0.1];

% Algorithm to extend acker() to multi input (since this will error)
%f = acker(A,B,poles)

% Check controllablility
disp('Check if A and B is controllable')
rank(ctrb(A,B))

% Find input such that x_1 ... x_n are independent
U = zeros(m,n + 1);
X = zeros(n,n + 1);

for idx = 1:n
    U_temp = [1;0];
    current_rank = rank(X);
    
    % If we find an independant vector, add and go to the next one
    x_new = A * X(:, idx) + B * U_temp;
    if current_rank < rank([X x_new])
        X(:, idx + 1) = x_new;
        U(:, idx) = U_temp;
    end
end

disp('Array with [x0 x1 x2 x3]')
disp(X)

disp('Array with [u0 u1 u2 u3]')
disp(U)


% Pick an arbitrary u_n
U(:,end) = rand(m,1);

% Find a F0 : F0 * [x1 x2 ... xn] = [u1 u2 ... un]
% Since [x1 x2 ... xn] is nxn and independant, we have that there exists an
% inverse. Hence F0 = [u1 u2 ... un] * inv([x1 x2 ... xn]).
F0 = U(:, 2:end) * inv(X(:, 2:end));

% Define b := B * u0
b = B * U(:,1);

% Solve pole placement for 1d input of (A + B * F0, b)
f = -acker(A + B * F0, b, poles);

disp('Eigenvalues of acker() input');
disp(eig(A + B * F0 + b * f))

F = F0 + U(:,1) * f;

disp('Eigenvalues of closed loop system');
disp(eig(A + B * F))






