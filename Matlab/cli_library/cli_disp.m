function [] = cli_disp(string,width)
%CLI_DISP display the content of the string with wordwraping.
% Default value of width is 76;

    % Setting default Matlab width
    if nargin < 2
        width = 76;
    end
    
    % Print the string
    disp(char(cli_word_wrap(string, width)));
end

