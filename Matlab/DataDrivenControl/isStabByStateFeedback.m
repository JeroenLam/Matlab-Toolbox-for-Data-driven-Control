function bool = isStabByStateFeedback(A, B)
%ISSTABBYSTATEFEEDBACK Returns if the data (X, U) is informative for stability for an autonomous system.
%   Detailed explanation goes here
    % Check data validity
    [Xm, Xp, n] = testDataInput(X);
    bool = false;
    % Method 1 (Check if the Moore Penrose inverse implies stability)
    if ( rank(Xm) == n ) && isStable( Xp * pinv(Xm) )
        bool = true;
        return;
    end
    % Method 2 (Matrix inequality)
end
