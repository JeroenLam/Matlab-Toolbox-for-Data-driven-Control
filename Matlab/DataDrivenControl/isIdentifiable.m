function bool = isIdentifiable(A, B)
%IDENTIFICATION Returns of data (X) or (U,X) is informative for system identification.
%   Detailed explanation goes here
    if ( nargin < 2 )
        % Check data validity
        [Xm, ~, n] = testDataInput(A);
        % Return if the rank if sufficient for system identification
        bool = ( rank(Xm) == n );
    else
        % Check data validity
        [Xm, ~, n, U, m] = testDataInput(A, B);
        % Return if the rank if sufficient for system identification
        bool = ( rank([Xm ; U]) == n + m );
    end
end