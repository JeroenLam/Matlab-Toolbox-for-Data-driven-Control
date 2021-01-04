            % Linear operator defined in Thr 29
            Lfunc = @(P) Xmin' * P * Xmin - Xplus' * P * Xplus - Xmin' * Q * Xmin - Umin' * R * U;
            
            % Define variable (Pplus is symmetric by construction)
            Pplus = sdpvar(n);
            
            % Add constraint
            C = [Pplus >= tolerance];
            C = C + [Lfunc(Pplus) <= -tolerance];
            
            % Solving the problem
            diagnosticsP = optimize(C, -trace(Pplus), options);
            
            % TODO: Recheck conditions
            
            % If no problems occured, calculate X-^-1
            if not(diagnosticsP.problem)
                % Define variable
                P = value(Pplus);
                Xinv = spdvar(size(Xmin,2), size(Xmin,1));
                
                % Add constraint
                C = [(Xmin * Xinv) == eye(size(Xmin,1))];
                C = C + [Lfunc(P) * Xinv == 0]
                
                % Solving the problem
                diagnosticsX = optimize(C, [], options);
                
                % TODO: Recheck conditions
                
                % If no problems occured, calculate K
                if not(diagnosticsX.problem)
                    K = Umin*value(Xinv);
                end
            end