function [bool, K] = isInformLQR(xData, uData, Q, R)
%ISINFORMLQR Summary of this function goes here
%   Detailed explanation goes here
    % Check data validity
    [Xm, Xp, n, U, m] = testDataInput(xData, uData);

    bool = false;
    K = [];
    
    % Based on Lemma 25
    % Case 1
    % The data is informative for system identification and the given
    % system is LQR solvable.
    if isIdentifiable(xData, uData)
        [A, B] = identification(xData, uData);
        [bool, K] = isLQRSolvable(A, B, Q, R);
        return;
    % Case 2
    % All systems describing the data have the same A matrix. Moreover A is
    % stable and QA = 0. The optimal feedback gain is given by K = 0;
    else
        cvx_begin quiet
            variable Theta(size(Xm,2), n)
            [ Xm * Theta    Xp * Theta ;
             (Xp * Theta)'  Xm * Theta ] >= 1e-8*eye(2*n)
          
            subject to
                Xm * Theta == (Xm * Theta)'
                U  * Theta == zeros(size(U  * Theta)
                Q  * Xp * Theta == zeros(size(Q  * Xp * Theta))
        cvx_end
        
        % Return true if Theta does not contain a NaN and is non zero
        if ( min(Xm * Theta == (Xm * Theta)') )
            bool = true;
            K = zeros(m, n);
        end
    end
end
