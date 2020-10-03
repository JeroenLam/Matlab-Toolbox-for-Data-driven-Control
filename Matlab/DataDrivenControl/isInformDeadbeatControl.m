function [bool, K] = isInformDeadbeatControl(A,B)
%ISINFORMDEADBEATCONTROL Summary of this function goes here
%   Detailed explanation goes here
    % Check data validity
    [Xm, Xp, n, U] = testDataInput(A, B);
    
    % Prepare return variables
    bool = false;
    K = [];
    
    if ( rank(Xm) == n )
        % Case where Xm is square
        if ( size(Xm,2) == n )
            if ( isNilpotent(Xp / Xm) ) 
                bool = true;
                K = U / Xm;
            end
        % Case where Xm is not square    
        else
            F = pinv(Xm);
            G = null(Xm);
            % Note that place() is unreliable for poles with multiplicity
            % Note acker is unreliable for order greater than 10
            H = acker(Xp*F, -Xp*G, zeros(1,n));
            K = U * ( F + G * H );
            bool = true;
        end
    end
end

