function bool = isStable(A)
    %ISSTABLE Returns if the matrix A is stable
    %   Detailed explanation goes here
        bool = false;
        spectrum = eig( A )
        for eigV = spectrum.'
            if ( abs(eigV) >= 1 )
                return;
            end
        end
        bool = true;
    end