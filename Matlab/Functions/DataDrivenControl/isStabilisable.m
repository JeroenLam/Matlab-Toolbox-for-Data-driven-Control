function bool = isStabilisable(X)
%ISStabilisable Returns if the data is informative for stabilisability.
%  Input:  X = matrix containing the measured state
%  Output: bool = true if stabilisable, false otherwise
%  Throws: InsufficientArguments  : Not enough input arguments.
%          NonNumericArgument     : Only provide numeric arguments!
%          EmptyStateData         : Provide a non empty state measurement matrix.

    TOLORANCE = 1e-14;

    % Check data validity
    try
        [Xmin, Xplus, n] = testDataInput(X);
    catch err
        rethrow(err)
    end
    
    % Define return value to be false unless otherwise shown
    bool = false;
    
    % Check if the rank is sufficient
    if rank(Xplus - Xmin) ~= n
        return
    end
        
    % For each non-zero eigenvalue we check if the rank condition holds
    spectrum = eig(Xmin * pinv(Xplus - Xmin));
    for eigV = spectrum.'
        if eigV ~= 0
            lambda = inv(eigV) + 1;
            if max(max(Xplus - lambda * Xmin)) < TOLORANCE
                %warning('Singular to working precision');
                return;
            end
            if rank(Xplus - lambda * Xmin) ~= n
                return
            end
        end
    end
    
    % If all conditions are met, return true
    bool = true;
end