function [bool, X_bar, U_bar, Y_bar] = isInformStateIdentification(U, Y, n)
%ISINFORMSTATEIDENTIFICATION Summary of this function goes here
%   Detailed explanation goes here

    bool = false;
    X_bar = [];
    U_bar = []; 
    Y_bar = [];
    
    if size(U,2) ~= size(Y,2)
        error("U and Y should have the same length");
    end
    % n : when n is not given?
    m = size(U, 1);
    k = rank(U);
    l = size(Y, 1);
    T = size(U,2);
    
    % Check length conditions
    if n < k && k < 0.5*T
        H_2k_u = BlockHankel(U(:,1:2*k), U(:,2*k:end));
        H_2k_y = BlockHankel(Y(:,1:2*k), Y(:,2*k:end));
        
        % Check rank condition of Hankel Block matrices
        if rank([H_2k_u ; H_2k_y]) == 2*k*m+n
            U_p = H_2k_u(1:end/2, :);
            U_f = H_2k_u(end/2 + 1:end, :);
            Y_p = H_2k_y(1:end/2, :);
            Y_f = H_2k_y(end/2 + 1:end, :);
            
            % Algorithm to find the X_f rowspace via the intersection
            % Method 1 (From paper [48 thr4])
            H1 = [Y_p ; U_p];
            H2 = [Y_f ; U_f];
            H  = [H1 ; H2];
            [U_h, S_h, ~] = svd(H);
            
            %    ┌ u_11 u_12 ┐┌ s_11 0 ┐
            % H =└ u_21 u_22 ┘└ 0    0 ┘V'
            s_11 = S_h(1 : 2 * m * k + n, 1 : 2 * m * k + n);
            u_11 = U_h(1 : (m + l) * k  , 1 : 2 * m * k + n);
            u_12 = U_h(1 : (m + l) * k  , 2 * m * k + n + 1 : end);
            
            %                                      ┌ s_q 0 ┐
            % u_12' * u_11 * s_11 = [ u_q u_q^┴ ] └ 0   0 ┘ V
            [U_q, S_q, ~] = svd(u_12' * u_11 * s_11);
            s_q_rank = rank(S_q);
            u_q = U_q(:, 1:s_q_rank);
            
            bool = true;
            X_bar = u_q' * u_12' * H1;
            U_bar = U(:, k + 1:T - k);
            Y_bar = Y(:, k + 1:T - k);
        end
    end
end

