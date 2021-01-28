function [bool] = isNilpotent(A)
%ISNULPOTENT returns of the matrix is nilpotent
    bool = false;
    if size(A,1) ~= size(A,2)
        return
    end

    testPoly = zeros(1,size(A,1) + 1);
    testPoly(1) = 1;
    if ( charpoly(A) == testPoly ) % test for nilpotence
        bool = true;
    end
end

