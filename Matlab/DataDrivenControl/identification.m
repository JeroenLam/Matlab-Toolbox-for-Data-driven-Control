function [trueA, trueB] = identification(A, B)
%IDENTIFICATION Returns if possible the true system A and B described by the data.
%   Detailed explanation goes here

    % Check data validity
    [Xm, Xp, n, U] = testDataInput(A, B);
    
    % Test if the system is Identifiable
    if ( not(isIdentifiable(A, B)) )
        errID = 'identification:NotIdentifiable';
        msg = 'The data is not informative for system identification.';
        baseException = MException(errID, msg);
        throw(baseException)
    end    

    % Find the right inverse
    rightInv = pinv([Xm ; U]);
    V1 = rightInv(:, 1:n);
    V2 = rightInv(:, n + 1:end);

    % Construct real system
    trueA = Xp * V1;
    trueB = Xp * V2;
end

