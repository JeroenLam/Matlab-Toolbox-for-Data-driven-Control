function bool = isInformStabilisable(X)
%ISStabilisable Returns if the data is informative for stabilisability.
%  Input:  X          = matrix containing the measured state
%  Output: bool = true if stabilisable, false otherwise
%  Throws: InsufficientArguments  : Not enough input arguments.
%          NonNumericArgument     : Only provide numeric arguments!
%          EmptyStateData         : Provide a non empty state measurement matrix.

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
    spectrum = sym(eig(Xmin * pinv(Xplus - Xmin)));
    for eigV = spectrum.'
        if abs(eigV) >= 0
            lambda = inv(eigV + 1);
            % Check if the data is singular to working precision
            if max(max(abs(Xplus - lambda * Xmin))) < 0
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