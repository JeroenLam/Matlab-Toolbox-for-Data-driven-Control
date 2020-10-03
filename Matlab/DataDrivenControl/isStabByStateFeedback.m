function [bool, K1, K2] = isStabByStateFeedback(A, B)
%ISSTABBYSTATEFEEDBACK Returns if the data (X, U) is informative for stability for an autonomous system.
%   Detailed explanation goes here
    % Check data validity
    [Xm, Xp, n, U] = testDataInput(A, B);
    
    % Prepare return variables
    bool = false;
    K1 = [];
    K2 = [];
    
    % Method 1 (Check if the Moore Penrose inverse implies stability)
    if ( rank(Xm) == n ) && isStable( Xp * pinv(Xm) )
        bool = true;
        K1 = U *  pinv(Xm);
        %return;
    end
    
    % Method 2 (Check stability using the matrix inequality)
    cvx_begin quiet
        variable Theta(size(Xm,2), n)           % Find a Theta,
        XmT = Xm*Theta;                         %
        XpT = Xp*Theta;                         %
        [ XmT XpT ; XpT' XmT ] >= 1e-8*eye(2*n) % Such that the matrix is positive definite,
        subject to                              %
            XmT == XmT'                         % While Xm * Theta is symmetric.
    cvx_end
    
    meq = eig([ XmT XpT ; XpT' XmT ])
    
    % Return true if Theta does not contain a NaN and is non zero
    if ( min(XmT == XmT') )
    %if ( sum(isnan(Theta), 'all') == 0 ) &&  sum( Theta ~= zeros(size(Theta)) , 'all')
        bool = true;
        K2 = U * Theta * inv(XmT);
    end   
end
