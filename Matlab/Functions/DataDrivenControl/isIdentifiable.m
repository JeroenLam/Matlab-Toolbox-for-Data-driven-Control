function bool = isIdentifiable(X, U)
%IDENTIFICATION Checks if the data is informative for system identification.
%  Input:  X = matrix containing the measured state
%          U = matrix containing the measured input (optional)
%  Output: bool = true if identifiable, false otherwise
%  Throws: The methods throws if the data is not of the correct format

    % Check data validity
    if nargin < 2
        [Xmin, ~, n, Umin, m] = testDataInput(X);
    else
        [Xmin, ~, n, Umin, m] = testDataInput(X, U);
    end
    
    % Return if the rank if sufficient for system identification
    bool = ( rank([Xmin ; Umin]) == n + m );
end