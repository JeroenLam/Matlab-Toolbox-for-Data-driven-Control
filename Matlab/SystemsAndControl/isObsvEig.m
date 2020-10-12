function [bool] = isObsvEig(C, A, lambda)
%ISOBSVEIG Summary of this function goes here
%   Detailed explanation goes here
    if size(A,1) ~= size(A,2) || size(A,2) ~= size(C,2)
        bool = false;
        % TODO: Throw parameterExcepsion
        return;
    end
    bool = rank([A - lambda * eye(size(A)) ; C]) == size(A,1);
end

