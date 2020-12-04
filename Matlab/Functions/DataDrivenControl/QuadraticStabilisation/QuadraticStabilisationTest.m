% System matrices
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
eig([eye(n,n) ; W']' * [W11 W12 ; W12' W22] * [eye(n,n) ; W']);


[b  ,K  , diag  ] = isInformQuadraticStabilisation(X  , U, W11, W12, W22);
[b_n,K_n, diag_n] = isInformQuadraticStabilisation(X_n, U, W11, W12, W22);


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

epsilons = [0.5 1 1.5 2 2.2 2.4];%[0:0.1:5];
%results = [];
rng(0,'twister');
        
for idx = 1:size(epsilons,2)
    epsilon = epsilons(idx);
    
    epsilon_array =zeros(1, 4); 
    stable_array = zeros(1, 4);
    bool_iqs_array = zeros(1,4);
    
    parfor iter = 1:100

        T = 20;

        W11 = T * epsilon * eye(n);
        W12 = zeros(n,T);
        W22 = -eye(T);

        x0 = normrnd(0,1,n,1);
        U  = normrnd(0,1,m,T);
        

        elevation = asin(2*rand(T,1)-1);
        azimuth = 2*pi*rand(T,1);
        radii = epsilon * rand(T,1).^(1/3);
        [x,y,z] = sph2cart(azimuth,elevation,radii);
        % sqrt(x.^2 + y.^2 + z.^2 )
        
        W = [x' ; y' ; z' ];

        [U, X] = generateData(A, B, x0, U, [], [], W);

        [b_iqs, K, d_iqs] = isInformQuadraticStabilisation(X, U, W11, W12, W22);
        
        %results.epsilon(iter) = epsilon;
        %results.K(iter) = mat2str(K);
        %results.b_iqs(iter) = b_iqs;
        %results.d_iqs_problem(iter) = d_iqs.problem;
        %results.d_iqs_info(iter) = d_iqs.info;
        %results.b_s(iter) = b_s;
        %results.d_s_problem(iter) = d_s.problem;
        %results.d_s_info(iter) = d_s.info;
        epsilon_array(iter) = epsilon;
        bool_iqs_array(iter) = b_iqs;
        if isempty(K)
            %results.true_stable(iter) = -1;
            stable_array(iter) = -1;
        else
            %results.true_stable(iter) = isStableD(A + B * K);
            stable_array(iter) = isStableD(A + B * K);
        end
        
        
        %results = [results structFactory(epsilon, K, b_iqs, d_iqs, b_s, d_s, A, B)];
        
        fprintf('e: %d -- iter: %d\n', epsilon, iter);
    end
    fileName = sprintf('csv/result-%d.csv', epsilon);
    results.e = epsilon_array';
    results.b_iqs = bool_iqs_array';
    results.stable = stable_array';
    struct2csv(results, fileName);
    clear results;
    %results = [];
end




%poolobj = parpool(7);
delete(poolobj);





disp('Generelised Slater condition eig(N) > 0');
N = [eye(n,n) X(:,2:end); zeros(n,n) -X(:,1:end-1); zeros(m,n) -U] * ...
        [W11 W12 ; W12' W22] * ...
        [eye(n,n) X(:,2:end); zeros(n,n) -X(:,1:end-1); zeros(m,n) -U]';
disp(sum(eig(N) > 0));









