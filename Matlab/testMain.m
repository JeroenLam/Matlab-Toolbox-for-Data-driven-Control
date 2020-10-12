A = [-6 -11 -6; 1 0 0; 0 1 0];
B = [1 ; 0 ; 0];
U = [ 0 0 0 0 ];
x0 = [1;0;0];
[U,X] = generateData(A,B,x0,U)

%X = [ 1 1 2 2 2 ]
%U = [ 0 0 0 0 ]
identifieable = isIdentifiable(X,U)
[An, Bn] = identification(U,X,true)
[X(:,1:end-1) ; U] * pinv([X(:,1:end-1) ; U])
symInv = symRightInverse([X(:,1:end-1) ; U])

ansA = solve(An == A)
%ansB = solve(Bn == B)
%newA = subs(An, ansA)
%newB = subs(Bn, ansB)