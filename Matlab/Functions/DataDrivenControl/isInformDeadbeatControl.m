function [bool, K] = isInformDeadbeatControl(X, U)
%ISINFORMDEADBEATCONTROL checks if the data is informative for deadbet
%control. If that is the case the function will also return a corresponding
%controller.
%  Input:  X = matrix containing the measured state
%          U = matrix containing the measured input
%  Output: bool = true if informative for deadbeat control, false otherwise
%          K    = the deadbet controller if applicable, [] otherwise 
%  Throws: The methods throws if the data is not of the correct format

    % Check data validity
    [Xmin, Xplus, n, Umin] = testDataInput(X, U);
    
    % Prepare return variables
    bool = false;
    K = [];
    
    if ( rank(Xmin) == n )
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
            H = acker(Xplus*F, -Xplus*G, zeros(1,n));
            K = Umin * ( F + G * H );
            bool = true;
        end
    end
end

