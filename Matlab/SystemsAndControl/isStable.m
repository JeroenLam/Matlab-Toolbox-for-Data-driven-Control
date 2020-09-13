function bool = isStable(A)
    %ISSTABLE Summary of this function goes here
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