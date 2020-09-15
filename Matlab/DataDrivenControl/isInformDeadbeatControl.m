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
            testPoly = zeros(1,n);
            testPoly(1) = 1;
            if ( charpoly(Xp / Xm) == testPoly ) % test for nilpotence
                bool = true;
                K = U / Xm;
            end
        % Case where Xm is not square    
        else
            
        end
    end
end

