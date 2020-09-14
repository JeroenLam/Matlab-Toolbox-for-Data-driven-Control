function bool = isStabByStateFeedback2(A, B)
%ISSTABBYSTATEFEEDBACK Returns if the data (X, U) is informative for stability for an autonomous system.
%   Detailed explanation goes here
    % Check data validity
    [Xm, Xp, n, U] = testDataInput(A, B);
    bool = false;
    
    % Method 1 (Check if the Moore Penrose inverse implies stability)
    if ( rank(Xm) == n ) && isStable( Xp * pinv(Xm) )
        bool = true;
        K1 = U *  pinv(Xm)
    %    return;
    end
    
    % Method 2 (Matrix inequality)
    cvx_begin quiet
        variable Theta(size(Xm,2), n)
        XmT = Xm*Theta;
        XpT = Xp*Theta;
        [ XmT XpT ; XpT.' XmT ] >= 1e-8
        subject to
            Xm * Theta == (Xm * Theta).'
    cvx_end
    Theta;
    XmT = Xm*Theta;
    XpT = Xp*Theta;
    eigenvalues = eig([ XmT XpT ; XpT.' XmT ]);
    K2 = U * Theta * inv(XmT)
end
