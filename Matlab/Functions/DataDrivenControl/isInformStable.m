function bool = isInformStable(X)
%ISINFORMSTABLE Returns if the data is informative for stability for an unforced system.
%  Input:  X = matrix containing the measured state
%  Output: bool = true if stable, false otherwise
%  Throws: InsufficientArguments  : Not enough input arguments.
%          NonNumericArgument     : Only provide numeric arguments!
%          InconsistentLengthData : The data is not the correst size, U should be 1 shorter than X.
%          EmptyStateData         : Provide a non empty state measurement matrix.
    
    % Define return value to be false unless otherwise shown
    bool = false;
    
    % Check if the system is identifiable and if so, if it is stable
    [bool_ident, A] = isInformIdentification(X);
    if bool_ident
        bool = isStableD(A);
    end
end

