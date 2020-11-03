function [] = ThetaValidity(Theta, Xmin, Xplus)
%THETAVALIDITY Summary of this function goes here
%   Detailed explanation goes here

    if Xmin * Theta ~= (Xmin * Theta).'
        disp("not symmetric");
        disp(Xmin * Theta - (Xmin * Theta).');
    end
    
    M = [ Xmin * Theta    Xplus * Theta ;
         (Xplus * Theta)'  Xmin * Theta ];
    
    if min(eig(M)) < 0
        disp("not pos. def.");
        disp(eig(M));
    end
end

