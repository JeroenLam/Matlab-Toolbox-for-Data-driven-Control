function [U, X] = generateData(A, B, x0, U)
%GENERATEDATA Summary of this function goes here
%   Detailed explanation goes here

    % Defining readable variables
    n  = size(A,1);         % Dim of statespace
    inputs = size(U,2);     % # of inputs
    
    X = zeros( n, inputs + 1 );
    X(:, 1) = x0;
    for idx = 1:inputs
        X(:, idx + 1) = A * X(:, idx) + B * U(:, idx);
    end
end

