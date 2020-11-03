function bool = isStabilisable(X, U)
%ISStabilisable Returns if the data is informative for stabilisability.
%  Input:  X = matrix containing the measured state
%          U = matrix containing the measured input
%  Output: bool = true if stabilisable, false otherwise
%  Throws: The methods throws if the data is not of the correct format

    % Check data validity
    [Xmin, Xplus, n] = testDataInput(X, U);

    % Define return value to be false unless otherwise shown
    bool = false;
    
    % Check if the rank is sufficient
    if rank( Xplus - Xmin ) == n
        return
    end
        
    % For each non-zero eigenvalue we check if the rank condition holds
    spectrum = eig( Xmin * pinv( Xplus - Xmin ) );
    for eigV = spectrum.'
        if eigV ~= 0
            lambda = inv(eigV) + 1;
            if ~(rank(Xplus - lambda * Xmin) == n)
                return
            end
        end
    end
    
    % If all conditions are met, return true
    bool = true;
end