function [bool] = isControllableEig(A, B, lambda)
%ISCONTEIG returns if the eigenvalue is controllable for the given system
    if size(A,1) ~= size(A,2) || size(A,1) ~= size(B,1)
        bool = false;
        % TODO: Throw parameterExcepsion
        return;
    end
    bool = rank([A - lambda * eye(size(A)) B]) == size(A,1);
end