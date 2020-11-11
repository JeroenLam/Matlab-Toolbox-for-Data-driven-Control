function bool = isInformControllable(X)
%ISCONTROLLABLE Returns if the data is informative for controllability.
%  Input:  X = matrix containing the measured state
%  Output: bool = true if controllable, false otherwise
%  Throws: InsufficientArguments  : Not enough input arguments.
%          NonNumericArgument     : Only provide numeric arguments!
%          EmptyStateData         : Provide a non empty state measurement matrix.

    % Check data validity
    try
        [Xmin, Xplus, n] = testDataInput(X);
	catch exception
        rethrow(exception)
    end
    
    % Define return value to be false unless otherwise shown
    bool = false;
    
    % Check if the rank is sufficient
    if rank(Xplus) ~= n 
        return
    end
    
    % For each non-zero eigenvalue we check if the rank condition holds
    spectrum = eig(Xmin * pinv(Xplus));
    for eigV = spectrum.'
        if eigV ~= 0 && ~(rank(Xplus - inv(eigV) * Xmin) == n)
        	return
        end
    end
    
    % If all conditions are met, return true
    bool = true;
end

