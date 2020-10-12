function [A, B] = identification(A, B)
%IDENTIFICATION Returns if possible the true system A and B described by the data.
%   Detailed explanation goes here
    % Check data validity
    [Xm, Xp, n, U] = testDataInput(A, B);
    
    % Test if the system is Identifiable
    if not(isIdentifiable(A, B))
        fprintf('The data is not informative for system identification.\n')
        return
    else
        % Find the right inverse
        inv = pinv([Xm ; U]);
    end
    
    V1 = inv(:, 1:n);
    V2 = inv(:, n + 1:end);

    % Construct real system
    A = Xp * V1;
    B = Xp * V2;
end