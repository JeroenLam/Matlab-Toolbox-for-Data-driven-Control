function [Xmin, Xplus, n, Umin, m, Ymin] = testDataInput(X, U, Y)
%TESTDATAINPUT (Support function) - Validates input data and returns usefull matrices and values.
%  Input:  X = matrix containing the measured state
%          U = matrix containing the measured input (optional)
%          Y = matrix containing the measured output (optional)
%  Output: Xmin  = State measurements without last column
%          Xplus = State measurements without first column
%          n     = Dimension of state space
%          Umin  = Input measurements
%          m     = Dimension of input space
%          Ymin  = Output measurements
%  Throws: InsufficientArguments  : Not enough input arguments.
%          NonNumericArgument     : Only provide numeric arguments!
%          InconsistentLengthData : The data is not the correst size, U should be 1 shorter than X.
%          EmptyStateData         : Provide a non empty state measurement matrix.

    switch nargin
        case 1
            if not(isnumeric(X))
                errID = 'testDataInput:NonNumericArgument';
                msg = 'Only provide numeric arguments!';
                error(errID, msg);
            end
            Umin = [];
            Ymin = [];
        case 2
            if not(isnumeric(X) && isnumeric(U))
                errID = 'testDataInput:NonNumericArgument';
                msg = 'Only provide numeric arguments';
                error(errID, msg);
            end
            if size(U,2) + 1 == size(X,2) || isempty(U)
                Umin = U;
                Ymin = [];
            else % Throw if data is not the correct size
                errID = 'testDataInput:InconsistentLengthData';
                msg = 'The data is not the correst size, U should be 1 shorter than X.';
                error(errID, msg);
            end
        case 3
            if not(isnumeric(X) && isnumeric(U) && isnumeric(Y))
                errID = 'testDataInput:NonNumericArgument';
                msg = 'Only provide numeric arguments';
                error(errID, msg);
            end
            if size(U,2) + 1 == size(X,2) || isempty(U)
                Umin = U;
                if size(Y,2) + 1 == size(X,2) || isempty(Y)
                    Ymin = Y;
                end
            else % Throw if data is not the correct size
                errID = 'testDataInput:InconsistentLengthData';
                msg = 'The data is not the correst size, U should be 1 shorter than X.';
                error(errID, msg);
            end
    end

    if isempty(X)
        errID = 'testDataInput:EmptyStateData';
        msg = 'Provide a non empty state measurement matrix.';
        error(errID, msg);
    end

    % Defining readable variables
    Xmin  = X(:, 1:end-1);     % X-
    Xplus = X(:, 2:end);       % X+
    n     = size(X,1);         % Dim of statespace
    m     = size(Umin,1);      % Dim of inputspace
end

