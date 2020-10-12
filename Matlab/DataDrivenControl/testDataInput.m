function [Xm, Xp, n, U, m] = testDataInput(A, B)
%TESTDATAINPUT (Support function) - Validates input data and returns usefull matrices and values.
%   Detailed explanation goes here
    if ( nargin < 2 )
        X = A;
        U = [];
    else
        if ( size(A,2) + 1 == size(B,2) )
            X = B;
            U = A;
        elseif ( size(B,2) + 1 == size(A,2) )
            X = A;
            U = B;
        else
            errID = 'testDataInput:InconsistentLengthData';
            msg = 'The data is not the correst size, U should be 1 shorter than X.';
            throw(MException(errID, msg))
        end
    end
    % Throw if data is to small

    % Defining readable variables
    Xm = X(:, 1:end-1);     % X-
    Xp = X(:, 2:end);       % X+
    n  = size(X,1);         % Dim of statespace
    m  = size(U,1);         % Dim of inputspace
end

