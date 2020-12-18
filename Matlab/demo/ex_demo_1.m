cli_disp('In this example we will consider data generated by the following system:', width);
A = [0 2 1;1 1 1;2 0 1]
B = [1 0;0 1;0 0]
fprintf('\n');

cli_press_any_key();
cli_disp('We will use this system to generate our data using the following intial state and input', width);
x0 = [0;0;0]
U = [1 0 0 1;2 1 0 1]
fprintf('\n');

cli_press_any_key();
cli_disp('This will result in the following state and input data', width);
[U, X] = generateData(A,B,x0,U)
fprintf('\n');

cli_press_any_key();
cli_disp('We can use this data to see if certain properties hold.',width);
options = [{'System identification'}; 
           {'Controllability'};
           {'Stabillisability'};
           {'State feedback (WIP)'};
           {'Deadbeat control (WIP)'};
           {'State identification / Dynamic measurement feedback (WIP)'};
           {'Show data again'};
           {'Exit example'}];

fprintf('\n');
response = cli_options(options, width);
while response ~= 8
    fprintf('\n');
    switch(response)
        case 1 % System Identification
            fprintf(cli_bf('System Identification\n'))
            cli_disp('For the data to be informative for system identification we need that the data is full rank, i.e. rank([X₋ ; U]) = 5.', width)
            disp([X(:,1:end-1) ; U]);
            cli_disp(join(['However, in our example the data matrices have rank at most rank 4 and hence the data is not informative for system identification. ' ...
                           'We can also verify this using the bool = isInformIdentification(X,U) function provided by this toolbox.'], ''), width)
            cli_disp(sprintf('bool = %d\n', isInformIdentification(X,U)), width)
            
        case 2 % Controllability
            fprintf(cli_bf('Controllability\n'))
            cli_disp(join(['For the data to be informative for controllability we need that X₊ is full row rank and that X₊ - λ * X₋ is full row rank for all λ ≠ 0 such that λ⁻¹∈σ(X₋ * (X₊)^i) where (X₊)^i is a right inverse of X₊. ' ... 
                           'We can check if this condition hold by using the function bool = isInformControllable(X) provided by this toolbox.']), width)
            cli_disp(sprintf('bool = %d\n', isInformControllable(X)), width)
            cli_disp(join(['As we can see the data is informative for controllability eventhough we are not able to uniquely identify the system that produced the data. ' ...
                           'Since the systems that discribe this data are all controllable we might be able to find a controller that stabilises all these system. ' ...
                           'However, this is not guaranteed since we need to find a controler that is applicable for all systems dyscribed by the data.'], ''), width)
                       
        case 3 % Stabillisability
            fprintf(cli_bf('Stabilisability\n'))
            cli_disp(join(['For the data to be informative for stabilisability we need that X₊ - X₋ is full row rank and that X₊ - λ * X₋ is full row rank for all λ ≠ 1 such that (λ-1)⁻¹∈σ(X₋ (X₊ - X₋)^i) where (X₊ - X₋)^i is a right inverse of X₊ - X₋. ' ... 
                           'We can check if this condition hold by using the function bool = isInformStabilisable(X) provided by this toolbox.']), width)
            cli_disp(sprintf('bool = %d\n', isInformStabilisable(X)), width)
            cli_disp(join(['As we can see the data is informative for stabilisability. ' ...
                           'This is what we would have expected since all systems described by the data are controllable and hence also stabilisable. '], ''), width)
            
        case 4 % State feedback
            fprintf(cli_bf('Stabilisation by state feedback\n'))
            cli_disp(join(['For the data to be informative for stabilisation by state feedback if X₋ has full row rank and there exists a right inverse (X₋)^i  of X₋ such that X₊ * (X₋)^i is stable. ' ...
                           'If we have such a right inverse that the controller is given by K = U * (X₋)^i. ' ... 
                           'We can check if this condition hold by using the function [bool, K] = isInformStateFeedback(X, U) provided by this toolbox.']), width)
            
            [b_sf, K_sf, diag_sf, info_sf] = isInformStateFeedback(X, U);
            cli_disp(sprintf('bool = %d\n', b_sf), width)
            cli_disp('K = ', width)
            disp(K_sf)
            
            cli_disp(join(['As we can see the data is not informative for stabilisation by state feedback. ' ...
                           'Even though it is the case that each of the individual systems that fit the data is controllable, we are not able to find a controller that works on all of these systems at the same time.'],''), width)
            
            
        case 5 % Deadbeat control
            fprintf(cli_bf('Stabilisation by deadbeat control\n'))
            
            
            %sprintf('The data is informative for deadbeat control: %d\n', isInformDeadbeatControl(X,U))
            
        case 6 % State identification and dynamic measurement feedback
            
            
        case 7 % Show data again   
            X
            U
    end
    fprintf('\n');
    response = cli_options(options, width);
end







