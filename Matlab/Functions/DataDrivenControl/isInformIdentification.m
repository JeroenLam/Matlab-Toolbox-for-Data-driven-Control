function [bool, A, B] = isInformIdentification(X, U)
%IDENTIFICATION Checks if the data is informative for system identification.
%  Input:  X = matrix containing the measured state
%          U = matrix containing the measured input (optional)
%  Output: bool = true if identifiable, false otherwise
%  Throws: InsufficientArguments  : Not enough input arguments.
%          NonNumericArgument     : Only provide numeric arguments!
%          InconsistentLengthData : The data is not the correst size, U should be 1 shorter than X.
%          EmptyStateData         : Provide a non empty state measurement matrix.

    % Check data validity
    try
        if nargin < 2
            [Xmin, Xplus, n, Umin, m] = testDataInput(X);
        else
            [Xmin, Xplus, n, Umin, m] = testDataInput(X, U);
        end
    catch exception
        rethrow(exception)
    end
    
    % Check if the rank is sufficient for system identification
    bool = ( rank([Xmin ; Umin]) == n + m );
    A = [];
    B = [];
    
    if bool
        % Find the right inverse
        inv = pinv([Xmin ; Umin]);

        % Sepperate the inverse
        V1 = inv(:, 1:n);
        V2 = inv(:, n + 1:end);

        % Construct real system
        A = Xplus * V1;
        B = Xplus * V2;
    end
end