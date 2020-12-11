function [bool, K] = isInformLQR_CVX(X, Umin, Q, R)
%ISINFORMLQR_CVX Summary of this function goes here
%   Detailed explanation goes here

    % Check data validity
    [Xmin, Xplus, n, Umin, m] = testDataInput(X, U);

    bool = false;
    K = [];
    
    % Based on Lemma 25
    % Case 1
    % The data is informative for system identification and the given
    % system is LQR solvable.
    if isIdentifiable(X, U)
        [A, B] = identification(X, U);
        [bool, K] = isLQRSolvable(A, B, Q, R);
        return;
    % Case 2
    % All systems describing the data have the same A matrix. Moreover A is
    % stable and QA = 0. The optimal feedback gain is given by K = 0;
    else
        cvx_begin quiet
            variable Theta(size(Xmin,2), n)
            [ Xmin * Theta    Xplus * Theta ;
             (Xplus * Theta)'  Xmin * Theta ] >= 1e-8*eye(2*n)
          
            subject to
                Xmin * Theta == (Xmin * Theta)'
                Umin  * Theta == zeros(size(Umin  * Theta))
                Q  * Xplus * Theta == zeros(size(Q  * Xplus * Theta))
        cvx_end
        
        % Return true if Theta does not contain a NaN and is non zero
        if ( min(Xmin * Theta == (Xmin * Theta)') )
            bool = true;
            %K = zeros(m, n);
            % TODO Calculate K based on Data
        end
    end
end

