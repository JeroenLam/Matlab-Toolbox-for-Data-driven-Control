function [Xmin, Xplus, n, Umin, m] = testDataInput(A, B)
%TESTDATAINPUT (Support function) - Validates input data and returns usefull matrices and values.
%  If A or B is empty or B is not provided then Umin will be the empty
%  matrix and m will be 0.
%  Input:  A = matrix containing the measured state or input
%          B = matrix containing the measured state or input (optional)
%  Output: Xmin  = State measurements without last column
%          Xplus = State measurements without first column
%          n     = Dimension of state space
%          Umin  = Input measurements
%          m     = Dimension of input space
%  Throws: The methods throws if the data is not of the correct format

    if nargin < 2
        X    = A;
        Umin = [];
    elseif size(A,2) + 1 == size(B,2) || isempty(A)
        X    = B;
        Umin = A;
    elseif size(B,2) + 1 == size(A,2) || isempty(B)
        X    = A;
        Umin = B;
    else % Throw if data is not the correct size
        errID = 'testDataInput:InconsistentLengthData';
        msg = 'The data is not the correst size, U should be 1 shorter than X.';
        throw(MException(errID, msg))
    end

    % Defining readable variables
    Xmin  = X(:, 1:end-1);     % X-
    Xplus = X(:, 2:end);       % X+
    n     = size(X,1);         % Dim of statespace
    m     = size(Umin,1);      % Dim of inputspace
end

