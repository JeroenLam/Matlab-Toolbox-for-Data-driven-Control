function bool = isInformStable(X)
%ISINFORMSTABLE Returns if the data is informative for stability for an unforced system.
%  Input:  X = matrix containing the measured state
%  Output: bool = true if stable, false otherwise
%  Throws: The methods throws if the data is not of the correct format
    
    % Define return value to be false unless otherwise shown
    bool = false;
    
    % Check if the system is identifiable and if so, if it is stable
    if isIdentifiable(X)
        bool = isStableD( identification(X) );
    end
end

