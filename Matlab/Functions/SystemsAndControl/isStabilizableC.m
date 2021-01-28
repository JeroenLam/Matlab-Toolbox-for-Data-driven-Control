function [bool] = isStabilizableC(A,B)
%ISSTABLED Returns if the matrix pair (A, B) is stabilizable for continuous
% time.
%  Input:  A = A matrix of the state space representation
%          B = B matrix of the state space representation
%  Output: bool = true if stable, false otherwise
    
    n = size(A,1);

    % For all eigenvalues
    spectrum = eig(A);
    for lambda = spectrum.'
        % If they are unstable
        if real(lambda) >= 0
            % Check if they are stabilizable
            if rank([A - lambda * eye(n) B]) ~= n
                bool = false;
                return
            end
        end
    end
    bool = true;
end

