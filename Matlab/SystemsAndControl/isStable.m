function bool = isStable(A)
    %ISSTABLE Returns if the matrix A is stable
    %   Detailed explanation goes here
        bool = false;
        spectrum = eig ( Xp * pinv(Xm) );
        for eigV = spectrum.'
            if ( eigV >= 0 )
                return;
            end
        end
        bool = true;
    end