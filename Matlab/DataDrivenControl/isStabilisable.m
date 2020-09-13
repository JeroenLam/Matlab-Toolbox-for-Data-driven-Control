function bool = isStabilisable(A, B)
%ISStabilisable Returns if the data (U, X) is informative for stabilizability.
%   Detailed explanation goes here
    % Check data validity
    [Xm, Xp, n] = testDataInput(A, B);

    % Check for stability using data driven Hautus test
    bool = false;
    if ( rank( Xp - Xm ) == n )
        spectrum = eig( Xm * pinv( Xp - Xm ) );
        for eigV = spectrum.'
            if eigV ~= 1
                lambda = (eigV - 1)^-1;
                if ~(rank(Xp - lambda * Xm) == n)
                    return
                end
            end
        end
        bool = true;
    end
end