X = [ 1 0.5 -1/4 ; 0 1 1 ];
U = [-1 -1];
disp("Run example 19")
%[bool, k1, k2] = isStabByStateFeedback(X,U)
[bool, k] = isInformDeadbeatControl(X,U)

X = zeros(2,3);
U = zeros(1,2);
disp("Run zeros test")
%[bool, k1, k2] = isStabByStateFeedback(X,U)

X = [ 0 0 1 ; 2 3 4 ];
U = [-1 -1];
disp("Run NaN test")
%[bool, k1, k2] = isStabByStateFeedback(X,U)
