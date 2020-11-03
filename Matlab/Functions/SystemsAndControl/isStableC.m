function bool = isStableC(A)
%ISSTABLEC Returns if the matrix A is stable for continuous time
%  Input:  A = A matrix of the state space representation
%  Output: bool = true if stable, false otherwise

    bool = true;

    % Check if all eigenvalues are in the negetive complex plane
    spectrum = eig(A);
    for lambda = spectrum.'
        if real(lambda) >= 0
            bool = false;
            return
        end
    end
end