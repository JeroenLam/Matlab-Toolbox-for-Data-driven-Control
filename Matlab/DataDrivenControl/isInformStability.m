function bool = isInformStability(X)
%ISINFORMSTABLE Returns if the data (X) is informative for stability for an autonomous system.
%   Detailed explanation goes here
    % Check data validity
    [Xm, Xp, n] = testDataInput(X);
    bool = false;
    if ( rank(Xm) == n )
        bool = isStable( Xp * pinv(Xm) );
    end
end

