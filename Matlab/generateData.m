function [U, X] = generateData(A, B, x0, U)
%GENERATEDATA Generates the data matrix U and X based on a system (A,B) and i.c. x0 using input U.
%   Detailed explanation goes here

    % Defining readable variables
    n  = size(A,1);         % Dim of statespace
    samples = size(U,2);    % # of samples / inputs
    
    X = zeros( n, samples + 1 );
    X(:, 1) = x0;
    for idx = 1:samples
        X(:, idx + 1) = A * X(:, idx) + B * U(:, idx);
    end
end

