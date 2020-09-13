function bool = isInformStability(X)
%ISSTABLE Summary of this function goes here
%   Detailed explanation goes here
    % Check data validity
    [Xm, Xp, n] = testDataInput(X);
    bool = false;
    if ( rank(Xm) == n )
        bool = isStable( Xp * pinv(Xm) );
    end
end

