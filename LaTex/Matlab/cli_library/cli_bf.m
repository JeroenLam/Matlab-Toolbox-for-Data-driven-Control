function [string_out] = cli_bf(string_in)
%CLI_BF Returns the string formated in bold
    string_out = join(['<strong>' string_in '</strong>'], '');
end

