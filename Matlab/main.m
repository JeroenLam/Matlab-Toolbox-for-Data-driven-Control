% Ident, !Cont
test1.A  = [ -2 0 ; 0 -1];
test1.B  = [2 ; 0];
test1.x0 = [0 ; 1];
test1.U  = [ 1 1 1 ];
[test1.U, test1.X] = generateData(test1.A, test1.B, test1.x0, test1.U);
disp(' - Test set 1 - ')
TestFunctions(test1)
disp(' ')

% !Ident, Cont
test2.X = [0 1 0 ; 0 0 1];
test2.U = [1 0];
disp(' - Test set 2 - ')
TestFunctions(test2)
disp(' ')

% !Ident, Cont
test3.A = [ 1 2 ; 3 4 ];
test3.B = [1 ; 2];
test3.U = [ 1 1 1 ];
test3.x0 = [0 ; 1];
[test3.U,test3.X] = generateData(test3.A,test3.B,test3.x0,test3.U);
disp(' - Test set 3 - ')
TestFunctions(test2)
disp(' ')
