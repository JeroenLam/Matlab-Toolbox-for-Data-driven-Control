function [bool, K] = isStabByStateFeedback(X, U)
%ISSTABBYSTATEFEEDBACK Returns if the data is informative for stability for an autonomous system.
%   Detailed explanation goes here
    % Check data validity
    [Xmin, Xplus, n, Umin] = testDataInput(X, U);
    
    % Prepare return variables
    bool = false;
    K = [];

    %Method 1 (Check if the Moore Penrose inverse implies stability)
    if rank(Xmin) == n && isStableD(Xplus * pinv(Xmin))
        bool = true;
        K = Umin *  pinv(Xmin);
        return;
    end 
end
