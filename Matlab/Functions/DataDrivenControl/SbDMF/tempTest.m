A = [0 3;1 5];
B = eye(2);
C = [1 0];
D = zeros(1,size(B,2));
x0 = [1;1];
U = [1 1 2 0 0;1 1 2 0 0];

[U, X, Y] = generateData(A, B, x0, U, C, D);

[bool,A,B,C,D] = isInformIdentification(X, U(1,:), Y)

% Case where U is not full rank
[bool, K, L, M] = isInformDynamicMeasurementFeedback(X, U, Y)

isStableD([A B*M;L*C K+L*D*M])


B = B(:,1);
U = U(1,:);
D = D(1,1);

% Case where U is full rank
[U, X, Y] = generateData(A, B, x0, U, C, D);
[bool2, K2, L2, M2] = isInformDynamicMeasurementFeedback(X, U, Y)

isStableD([A B*M2;L2*C K2+L2*D*M2])