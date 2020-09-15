function bool = isStable(A)
    %ISSTABLE Returns if the matrix A is stable
    %   Detailed explanation goes here
        bool = sum( abs( eig(A) ) >= 1 , 'all') == 0;
    end