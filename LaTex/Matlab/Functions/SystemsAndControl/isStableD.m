function bool = isStableD(A)
%ISSTABLED Returns if the matrix A is stable for discrete time
%  Input:  A = A matrix of the state space representation
%  Output: bool = true if stable, false otherwise

    % Check if all eigenvalues are in the unit circle
    bool = max(abs(eig(A))) < 1;
end