%% System matrices
%A = [ 0 1 ; -1 -1]; % Stable
A = [ 0 0.75 ; 3 0 ];  % Unstable
B = [ 0 ; 1];

%Input and i.c.
U = [3 1 0 2];
x0 = [0;0];

% Defining constants and allocating memory
n  = size(A,1);
samples = size(U,2);

% Defining the noice we will use
%W = 0.1*(rand([n samples]) - 0.5);
W = [-0.0061    0.0266   -0.0313   -0.0054;
     -0.0118    0.0295   -0.0010    0.0146];

% Generating non noisy data samples
[U, X]   = generateData(A, B, x0, U);
[U, X_n] = generateData(A, B, x0, U, [], [], W);

% Finding the noice matrix (Seems to work for all W generated above)
W11 = 0.1*eye(n); % n*n
W12 = zeros(n,samples); % n*T
W22 = -0.1*eye(samples); % T*T
Phi = [W11 W12 ; W12' W22];
eig([eye(n,n) ; W']' * Phi * [eye(n,n) ; W']);


[b  ,K  , diag  ] = isInformQuadraticStabilisation(X  , U, Phi);
[b_n,K_n, diag_n] = isInformQuadraticStabilisation(X_n, U, Phi);


% ***************************************** 
%              Example paper
% ***************************************** 
poolobj = parpool(4);

clear all
A = [0.85 -0.038 -0.38 ; 0.735 0.715 1.594 ; -0.664 0.697 -0.064];
B = [1.431 0.705; 1.620 -1.129; 0.913 0.369];
n = size(A,2);
m = size(B,2);

% After running simulations
% 83    67    66    63    64    64

epsilons = [2 2.2 2.4];
% [0.5 1 1.5 2 2.2 2.4];
%results = [];
rng(0,'twister');
        
for idx = 1:size(epsilons,2)
    epsilon = epsilons(idx);
    
    epsilon_array =zeros(1, 4); 
    stable_array = zeros(1, 4);
    bool_iqs_array = zeros(1,4);
    info_array = zeros(1,4);
    parfor iter = 1:100

        T = 20;

        W11 = T * epsilon * eye(n);
        W12 = zeros(n,T);
        W22 = -eye(T);
        Phi = [W11 W12 ; W12' W22];
        
        x0 = normrnd(0,1,n,1);
        U  = normrnd(0,1,m,T);
        

        elevation = asin(2*rand(T,1)-1);
        azimuth = 2*pi*rand(T,1);
        radii = epsilon * rand(T,1).^(1/3);
        [x,y,z] = sph2cart(azimuth,elevation,radii);
        % sqrt(x.^2 + y.^2 + z.^2 )
        
        W = [x' ; y' ; z' ];

        [U, X] = generateData(A, B, x0, U, [], [], W);

        [b_iqs, K, ~, info] = isInformQuadraticStabilisation(X, U, Phi);

        epsilon_array(iter) = epsilon;
        bool_iqs_array(iter) = b_iqs;
        if isempty(K)
            %results.true_stable(iter) = -1;
            stable_array(iter) = -1;
        else
            %results.true_stable(iter) = isStableD(A + B * K);
            stable_array(iter) = isStableD(A + B * K);
            if stable_array(iter) == 0
                disp(A)
                disp(B)
                disp(U)
                disp(W)
                disp(x0)
            end
        end
        info_array(iter) = info;
        
        
        %results = [results structFactory(epsilon, K, b_iqs, d_iqs, b_s, d_s, A, B)];
        
        fprintf('e: %d -- iter: %d\n', epsilon, iter);
    end
    fileName = sprintf('csv/result-%d.csv', epsilon);
    results.e = epsilon_array';
    results.b_iqs = bool_iqs_array';
    results.stable = stable_array';
    results.info = info_array';
    %struct2table(results)
    %struct2csv(results, fileName);
    clear results;
    %results = [];
end




%poolobj = parpool(7);
delete(poolobj);

%% System and data that is a false positive
A = [0.8500   -0.0380   -0.3800;
     0.7350    0.7150    1.5940;
    -0.6640    0.6970   -0.0640];

B = [1.4310    0.7050;
     1.6200   -1.1290;
     0.9130    0.3690];

U = [-1.8161   -0.0341    0.9124    0.3168   -1.5205    0.0881    2.0609    0.1490    0.3192    0.0358   -1.1494    2.5987   -0.5493    0.3987    1.1325    1.1355   -1.5520   -1.0067   -1.7310    0.1360;
     -0.1133   -1.2714    0.2271    0.9742   -0.4673    1.4103    0.2187    0.0119    0.2139    0.1236    0.2317   -0.7843    0.3665   -0.3430   -0.1440    0.1393    0.5212    0.5662    0.1692   -0.8027];



W = [-1.3486   -1.2741   -1.3087    0.1668   -0.6339    1.3572    1.2121   -1.1908    0.0177    0.2349   -0.8083    1.1524    0.3585    0.6909   -0.2624   -0.0251   -0.2356   -1.3489   -0.5913    0.4394;
      0.7769   -0.3396   -0.1260   -1.5988   -0.7892    0.9051    1.8463   -0.1403   -0.9363    1.9608    1.4203   -1.0982   -0.8441    1.1236   -0.6345   -1.9983    0.5897    1.0861    1.8885    1.6879;
     -0.1833    1.1915   -0.0910    0.3549   -1.3461    1.2292    0.1195    1.9561    0.6079    1.1140   -1.3216   -0.7599    1.2423   -0.6436    1.8334    0.1416   -2.0132    0.7923    0.1876   -1.5865];

x0 = [-0.6606;
       1.1780;
      -0.6533];

[U, X] = generateData(A, B, x0, U, [], [], W);

n = 3;
T = 20;
epsilon = 2.4;

W11 = T * epsilon * eye(n);
W12 = zeros(n,T);
W22 = -eye(T);
Phi = [W11 W12 ; W12' W22];

[b_iqs, K, d_iqs, info] = isInformQuadraticStabilisation(X, U, Phi);

fprintf('isInform?: %d\n', b_iqs);
fprintf('info: %d\n', info);
fprintf('is the resulting system stable?: %d\n', isStableD(A + B * K));
fprintf('Slater condition: %d\n', testSlater(X,U,W11,W12,W22));
fprintf('Noice bound W11 - W*W^t >= 0: %d\n', min(eig(W11 - W*W')) >= 0);






