function [A, B] = identification(A, B, boolSym)
%IDENTIFICATION Returns if possible the true system A and B described by the data.
%   Detailed explanation goes here
    if nargin < 3
        boolSym = false;
    end

    % Check data validity
    [Xm, Xp, n, U] = testDataInput(A, B);
    
    % Test if the system is Identifiable
    if not(isIdentifiable(A, B))
        fprintf('The data is not informative for system identification.\n')
        if boolSym
            fprintf('Note, there is a symbolic solution:\n');
            A = [Xm ; U];
            if size(A,1) > size(A,2)    % wide matrix
                % Find the left inverse of A
                inv = symRightInverse(A')';
            else                        % tall matrix
                inv = symRightInverse(A);
            end
        else
            return
        end
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