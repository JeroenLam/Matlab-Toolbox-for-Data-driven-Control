function bool = isControllable(A, B)
%ISCONTROLLABLE Returns if the data (U, X) is informative for controllability.
%   Detailed explanation goes here
    % Check data validity
    [Xm, Xp, n] = testDataInput(A, B);
   
    bool = false;
    if ( rank(Xp) == n )
        spectrum = eig(Xm * pinv(Xp));
        for eigV = spectrum.'
            if eigV ~= 0
                if ~(rank(Xp - eigV * Xm) == n)
                    return
                end
            end
        end
        bool = true;
    end
end

