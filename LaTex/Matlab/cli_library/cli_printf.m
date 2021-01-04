function [] = cli_printf(string,width)
%CLI_PRINTF display the content of the string with wordwraping.
% Default value of width is 76;

    % Setting default Matlab width
    if nargin < 2
        width = 76;
    end
    
    % Print the string
    lines = char(cli_word_wrap(string, width));
    for idx = 1:size(lines,1)
        fprintf(lines(idx,:));
    end
end

