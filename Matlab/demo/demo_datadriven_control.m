% This script contains the code for the demo program of the data driven
% control toolbox.
width = 110;
fprintf('\n\n\n\n\n\n\n')
cli_disp(join(['Welcome to the demo program of the data driven control toolbox. ' ...
               'This toolbox is made by Jeroen Lammers and is based on the algorithms described in the papers [1] and [2]. ' ...
               'In this demo we will introduce the provided functions based on example data. ' ...
               'We will show how we can use the functions to get the desired output.']), width);

fprintf('\n');
cli_disp('[1]: Henk J. van Waarde et al.Data informativity: a new perspective on data-driven analysis andcontrol. 2019. arXiv:1908.00468 [math.OC].', width);
cli_disp('[2]: Henk J. van Waarde, M. Kanat Camlibel, and Mehran Mesbahi. From noisy data to feed-back controllers: non-conservative design via a matrix S-lemma. 2020. arXiv:2006.00870[math.OC].', width);
fprintf('\n');

cli_disp('We will by choosing an example to consider:', width);
options = [{'Example using a 3 dimensional state and a 2 dimensional input'}; 
           {'Example using a unidentifiable system (WIP)'};
           {'Example using .... (WIP)'};
           {'Recap of notation / theory (WIP)'};
           {'References (WIP)'}];
switch(cli_options(options, width))
    case 1
        ex_demo_1
    case 2
        
    case 3
        
    case 4
        
    case 5
        
    case 6
        
end