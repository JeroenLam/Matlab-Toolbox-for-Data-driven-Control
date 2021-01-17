function [H] = BlockHankel(c,r)
%BLOCKHANKEL Returns a Hankel matix containing blocks of the form c(:,i)
%and r(:,i). 
%   Detailed explanation goes here
    
    if size(c,1) ~= size(r,1)
        warning('c and r need to have the same block size');
        return;
    end
    
    if c(:,end) ~= r(:,1)
        warning('last element of c and first element of r are not the same, first element of r will be discarded');
    end
    
    elements = [c r(:,2:end)];
    
    block_size = size(c,1);
    height = size(c,2);
    width = size(r,2);
    
    H = zeros(height * block_size, width);
    h_idx = 1:block_size:height*block_size;
    for h = 1:height
        for w_idx = 1:width
            H(h_idx(h):h_idx(h) + block_size - 1, w_idx) = elements(:,h + w_idx - 1);
        end
    end
end

