function [U, X, Y] = generateData(A, B, x0, U, C, D, W)
%GENERATEDATA Generates the data matrix U and X based on a system (A,B) 
%and i.c. x0 using input U.
%   Detailed explanation goes here

    % Defining readable variables
    n  = size(A,1);         % Dim of statespace
    samples = size(U,2);    % # of samples / inputs
    
    if nargin < 7
        W = zeros(n, samples);
    end
    
    X = zeros( n, samples + 1 );
    X(:, 1) = x0;
    Y = [];
    for idx = 1:samples
        X(:, idx + 1) = A * X(:, idx) + B * U(:, idx) + W(:, idx);
        if nargin == 6
            Y = [Y C * X(:, idx) + D * U(:, idx)];
        end
    end
end

