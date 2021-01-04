classdef isStabilisableTest < matlab.unittest.TestCase
%ISSTABILISABLETEST Unit testing for isStabilisable(X)
%   This file contains all unit test used to verify the implementation is
%   working as expected. The test can be run using:
%     result = run(isStabilisableTest)
%   The unit test are implemented using matlab.unittest.TestCase
    
    % Used for reusing code from other tests for different functions
    properties
        func = @(X)isInformStabilisable(X);
    end

    % Unit tests for the isStabilisable(X) function
    methods (Test)
        function testInsufficientRank(testCase)
            % Tests if the function returns false for rank(Xplus - Xmin)~=n
            X = [1 1];
            testCase.verifyFalse(testCase.func(X));
            X = [2 2 2; 1 2 3];
            testCase.verifyFalse(testCase.func(X));
            
        end
        
        function testIncorrectEigenvalue(testCase)
            % Test case where the rank condition does not hold for the
            % eigenvalues.
            X = [1 2];
            testCase.verifyFalse(testCase.func(X));
        end
        
        function testCorrectData(testCase)
            % Test if the function returns the correct value for a valid
            % data set (eig(Xmin * pinv(Xplus - Xmin)) != 0)
            X = [-10 -10 -9;-10 -2 2];
            testCase.verifyTrue(testCase.func(X));
        end
        
        function testCorrectDataZero(testCase)
            % Test if the function returns the correct value for a valid
            % data set (eig(Xmin * pinv(Xplus - Xmin)) == 0)
            X = [0 0 1;0 2 2];
            testCase.verifyTrue(testCase.func(X));
        end
    end
    
    % Unit tests errors/exceptions for the isStabilisable(X) function
    methods (Test)
        function testEmptyState(testCase)
            % Test for the EmptyStateData error
            X = [];
            errorId = 'testDataInput:EmptyStateData';
            testCase.verifyError(@() testCase.func(X), errorId);
        end
        
        function testNoArguments(testCase)
            % Test providing no arguments
            errorId = 'MATLAB:minrhs';
            testCase.verifyError(@() testCase.func(), errorId);
        end
            
        function testNonNummericXU(testCase)
            % Test non numeric input X 
            A = 'not a matrix';
            errorId = 'testDataInput:NonNumericArgument';
            testCase.verifyError(@() testCase.func(A), errorId);
        end
    end
end

