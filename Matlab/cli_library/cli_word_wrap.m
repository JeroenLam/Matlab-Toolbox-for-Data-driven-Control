function [stringArray] = cli_word_wrap(string, width)
%CLI_WORD_WRAP returns an array of string based on the provided width. 
%Default width is 76.

    % Setting default Matlab width
    if nargin < 2
        width = 76;
    end

    stringArray = [];
    cur_line_str = '';
    words = split(string);
        
    for idx_word = 1:size(words,1)
        word = char(words(idx_word));
        % Add new word to the disp_str if it is short enough
        if size(cur_line_str, 2) + size(word,2) > width
            % If the current line is non empty, end it and start a new
            % line
            if size(cur_line_str, 2) > 0
                stringArray = [stringArray; cellstr(strip(char(cur_line_str)))];
                cur_line_str = '';
            end
                
            % Check if the word is to long, if so, split it
            while (size(word,2)) > width
                cur_line_str = join([cur_line_str ' ' extractBetween(word, 1,width-1) '-'],'');
                stringArray = [stringArray; cellstr(strip(char(cur_line_str)))];
                cur_line_str = '';
                word = extractAfter(word,width-1);
            end
        end
        cur_line_str = join([cur_line_str ' ' word], '');
    end
    stringArray = [stringArray; cellstr(strip(char(cur_line_str)))];
end