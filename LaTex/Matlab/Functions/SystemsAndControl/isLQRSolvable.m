function [bool, K] = isLQRSolvable(A, B, Q, R)
%ISLQRSOLVABLE Summary of this function goes here
%   Detailed explanation goes here
    bool = true;
    K = [];
    
    % Testing if the data is solvable using Thr 23.iii
    if isStabilizableD(A,B)
        spectrum = eig(A);
        for eigenvalue = spectrum'
            if abs(eigenvalue) == 1 && ~isObsvEig(Q, A, eigenvalue)
                bool = false;
                return;
            end
        end
        K = dlqr(A, B, Q, R, 0);
    end
end

