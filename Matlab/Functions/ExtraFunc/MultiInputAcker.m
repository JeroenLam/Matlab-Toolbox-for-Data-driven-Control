function [K] = MultiInputAcker(A, B, poles)
%MULTIINPUTACKER An extension to the ackerman function such that it
%supports multi dimensional input. i.e. size(B) = nxm instead of nx1
%   This function extends the acker(a,b,p) function of matlab to add multi
%   input support to it. The function will return a controller of the form 
%   A + B * K with poles places by the acker(a,b,p) function The method is 
%   based on the 'Proof of the sufficiency in theorem 3.29' from the book 
%   'Control theory for linear systems' by H.L. Trentelman, A.A. Stoorvogel
%   and M. Hautus.

    n = size(A,2);
    m = size(B,2);
    
    % Check if the system is controllable
    if rank(ctrb(A,B)) ~= n
        error('Please provide a controllable system');
    end
    
    % Find input such that x_1 ... x_n are independent
    U = zeros(m,n + 1);
    X = zeros(n,n + 1);
    
    % Find u_i such that the resulting x_i+1 is independent from the
    % previously found values x_i.
    for idx = 1:n
        current_rank = rank(X);

        running = true;
        while running
            % TODO: Find a smarter choice for U_temp (We want to find a
            % basis for R^n based on an iterative map using A and B).
            U_temp = rand(m,1);
            x_new = A * X(:, idx) + B * U_temp;
            % If x_new is independent w.r.t. the previously found x_i
            if current_rank < rank([X x_new])
                X(:, idx + 1) = x_new;
                U(:, idx) = U_temp;
                running = false;
            end
        end
    end
    
    % Pick an arbitrary u_n
    U(:,end) = rand(m,1);

    % Find a F0 : F0 * [x1 x2 ... xn] = [u1 u2 ... un]
    % Since [x1 x2 ... xn] is nxn and independant, we have that there exists an
    % inverse. Hence F0 = [u1 u2 ... un] * inv([x1 x2 ... xn]).
    F0 = U(:, 2:end)/X(:, 2:end);

    % Define b := B * u0
    b = B * U(:,1);

    % Solve pole placement for 1d input of (A + B * F0, b)
    f = -acker(A + B * F0, b, poles);
    
    % Find the resulting K
    K = F0 + U(:,1) * f;
end

