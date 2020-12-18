function [option_num] = cli_options(options, width)
%CLI_OPTIONS Summary of this function goes here
%   Detailed explanation goes here

    % Setting default Matlab width
    if nargin < 3
        width = 76;
    end

    % Store the number of prompts to show
    num_options = size(options,1);
    
    % Determine prefix spacing
    max_value_size = strlength(string(num_options));   % Max width of values
    prefix_size = max_value_size + 1;                  % Max width values + leading space
    prefix_str = sprintf('%%%dd) %%s\n', prefix_size); % Preparing c string for leading zeros and ') '
    total_prefix_size = prefix_size + 2;               % total size '  NUM) ' of prefix
    empty_prefix = sprintf('%%%ds%%s\n', total_prefix_size);
    
    % Printing options
    for item = 1:num_options
        stringArray = cli_word_wrap(options(item), width - total_prefix_size);
        fprintf(prefix_str, item, char(stringArray(1)));
        if length(stringArray) > 1
            for idx = 2:length(stringArray)
                fprintf(empty_prefix, '', char(stringArray(idx)));
            end
        end
    end
    
    % Requesting user input
    awnser = input('Please select an option? ');
    while ~(isnumeric(awnser) && ...
            min(size(awnser) == [1 1]) && ...
            0 < awnser && ...
            awnser <= num_options)
        awnser = input('Please provide a valid option? ');
    end
    option_num = awnser;
end