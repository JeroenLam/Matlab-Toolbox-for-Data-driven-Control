function [bool] = isDetectableC(C, A)
%ISSTABLED Returns if the matrix pair (C, A) is detectable for continuous
% time.
%  Input:  A = A matrix of the state space representation
%          B = B matrix of the state space representation
%  Output: bool = true if stable, false otherwise
    
    bool = isStabilizableC(A.', C.');
end
