function [A, B] = identification(X, U)
%IDENTIFICATION Returns if possible the true system A and B described by the data.
%  If the data is not informative for system identification, it will return
%  2 empty matrices and print an appropriate message.
%  Input:  X = matrix containing the measured state
%          U = matrix containing the measured input (optional)
%  Output: A = A matrix of the state space model representation
%          B = B matrix of the state space model representation
%  Throws: The methods throws if the data is not of the correct format

    % Used to support system identification of unforced systems
    if nargin < 2
        U = [];
    end
    
    % Test if the system is Identifiable
    if not(isIdentifiable(X, U))
        fprintf('The data is not informative for system identification.\n')
        return
    end
    
    % Check data validity
    [Xmin, Xplus, n, Umin] = testDataInput(X, U);
    
    % Find the right inverse
    inv = pinv([Xmin ; Umin]);
    
    % Sepperate the inverse
    V1 = inv(:, 1:n);
    V2 = inv(:, n + 1:end);

    % Construct real system
    A = Xplus * V1;
    B = Xplus * V2;
end