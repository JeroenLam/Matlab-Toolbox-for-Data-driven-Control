function [bool, K] = isInformDeadbeatControl(X, U)
%ISINFORMDEADBEATCONTROL checks if the data is informative for deadbeat
% control. If that is the case the function will also return a 
% corresponding stabilising controller.
%  Input:  X = matrix containing the measured state
%          U = matrix containing the measured input
%  Output: bool = true if informative for deadbeat control, false otherwise
%          K    = the deadbeat controller A + BK if applicable, [] otherwise
%  Throws: InsufficientArguments  : Not enough input arguments.
%          NonNumericArgument     : Only provide numeric arguments!
%          InconsistentLengthData : The data is not the correst size, U should be 1 shorter than X.
%          EmptyStateData         : Provide a non empty state measurement matrix.

    % Check data validity
    try
        [Xmin, Xplus, n, Umin] = testDataInput(X, U);
    catch exception
        rethrow(exception)
    end
    
    % Prepare return variables
    bool = false;
    K = [];
    
    if rank(Xmin) == n
        % Case where Xm is square
        if ( size(Xmin,2) == n )
            if ( isNilpotent(Xplus / Xmin) ) 
                bool = true;
                K = Umin / Xmin;
            end
        % Case where Xm is not square    
        else
            F = pinv(Xmin);
            G = null(Xmin);
            % Note that place() is unreliable for poles with multiplicity
            % Note acker is unreliable for order greater than 10
            % Note acker does not nativly support multi-dimensional input
            if rank(ctrb(Xplus*F, Xplus*G)) == n
                H = heymann(Xplus*F, Xplus*G, zeros(1,n));
                K = Umin * ( F + G * H );
                bool = true;
            end
        end
    end
end

