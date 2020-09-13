function bool = isStable(X)
%ISSTABLE Summary of this function goes here
%   Detailed explanation goes here
    % Check data validity
    [Xm, Xp, n] = testDataInput(X);
    bool = false;
    if ( rank(Xm) == n )
        spectrum = eig ( Xp * pinv(Xm) );
        for eigV = spectrum.'
            if ( eigV >= 0 )
                return;
            end
        end
    end
    bool = true;
end

