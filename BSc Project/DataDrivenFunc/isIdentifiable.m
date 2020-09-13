function bool = isIdentifiable(A, B)
%IDENTIFICATION Summary of this function goes here
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