function [bool, K] = StateFeedbackCVX(X, U, tolerance)
%STATEFEEDBACKCVX Summary of this function goes here
%   Detailed explanation goes here

    % Check data validity
    [Xmin, Xplus, n, Umin] = testDataInput(X, U);
    
    % Prepare return variables
    bool = false;
    K = [];

    % Define default solver and setting
    if nargin < 3
        tolerance = 1e-8;
    end
    
    % Method 2 (Check stability using the matrix inequality)
    cvx_begin quiet
        variable XminTheta(n,n) symmetric
        Theta = pinv(Xmin) * XminTheta;
        [ XminTheta        Xplus * Theta ;
         (Xplus * Theta).' XminTheta      ] >= tolerance;
    cvx_end

    % DEBUG REMOVE LATER ON
    ThetaValidity(Theta, Xmin, Xplus)
    
    % Return true if Theta does not contain a NaN and is non zero
    if min(XminTheta == (XminTheta)')
    %if ( sum(isnan(Theta), 'all') == 0 ) &&  sum( Theta ~= zeros(size(Theta)) , 'all')
        bool = true;
        K = Umin * Theta * inv(XminTheta);
    end   
end
