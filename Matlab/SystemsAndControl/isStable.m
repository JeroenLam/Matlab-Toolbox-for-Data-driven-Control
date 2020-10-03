function bool = isStable(A)
    %ISSTABLE Returns if the matrix A is stable
    %   Detailed explanation goes here
        bool = max(abs(eig(A))) < 1;
    end