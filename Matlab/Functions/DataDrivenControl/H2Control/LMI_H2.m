function [success,K,gamma] = LMI_H2(Xm,Xp,U,Phi,C,D,E,options,tol)
    [n,T] = size(Xm);
    [m,~] = size(U);
    [p,~] = size(C);
    [~,d] = size(E);
    
    outermatrix = [eye(n) Xp;zeros(n,n) -Xm;zeros(m,n) -U;zeros(n+p,n+T)];
    N = outermatrix*Phi*outermatrix';
    eigenv = eig(N);
    %display(eigenv(end-5:end));
    Y = sdpvar(n,n);
    Z = sdpvar(d,d);
    L = sdpvar(m,n);
    alpha = sdpvar(1,1);
    beta = sdpvar(1,1);
    gamma = sdpvar(1,1);
    LMI = [([Y-beta*eye(n) zeros(n,2*n+m+p);zeros(n,2*n+m) Y zeros(n,p);zeros(m,2*n+m) L zeros(m,p);zeros(n,n) Y L' Y (C*Y+D*L)';zeros(p,2*n+m) C*Y+D*L eye(p)]-alpha*N)>=zeros(3*n+m+p,3*n+m+p),
           [Y (C*Y+D*L)';(C*Y+D*L) eye(p)]>=tol*eye(n+p),
           [Z E';E Y]>=zeros(n+d,n+d),
           trace(Z)<=gamma,
           beta>=tol,
           alpha>=tol,
           Y>=tol*eye(n)];
    diag = optimize(LMI,gamma,options);
    Y = value(Y);
    L = value(L);
    success = 1;
    K = L/Y;
    gamma = value(gamma);
end

