A = [ 1 0.5 -1/4 ; 0 1 1 ];
B = [-1 -1];
[Xm, Xp, n, U] = testDataInput(A, B);

% Method 1 (Check if the Moore Penrose inverse implies stability)
%    if ( rank(Xm) == n ) && isStable( Xp * pinv(Xm) )
%        bool = true;
%        K1 = U *  pinv(Xm);
%        %return;
%    end
    
if ( rank(Xm) == n )
    cvx_begin quiet
        variable Y(size(Xm.'))
        Xm * Y == eye(size(Xm,2))
        subject to
            isStable(Xm * Y)
    cvx_end
    K = U * Y 
end
