function [bool] = isContEig(A, B, lambda)
%ISCONTEIG Summary of this function goes here
%   Detailed explanation goes here
    if size(A,1) ~= size(A,2) || size(A,1) ~= size(B,1)
        bool = false;
        % TODO: Throw parameterExcepsion
        return;
    end
    bool = rank([A - lambda * eye(size(A)) B]) == size(A,1);
end