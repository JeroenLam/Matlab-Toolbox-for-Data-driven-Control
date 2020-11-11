classdef testTemplate < matlab.unittest.TestCase
%<NAME TEST> Unit testing for <name func>(X,U)
%   This file contains all unit test used to verify the implementation is
%   working as expected. The test can be run using:
%     result = run(<name test>)
%   The unit test are implemented using matlab.unittest.TestCase

    % Used for reusing code from other tests for different functions
    properties
        func = @(X,U)isStabilisable(X,U);
    end
    
    % Unit tests for the <name func>(X,U) function
    methods (Test)
        
    end
    
    % Unit tests errors/exceptions for the <name func>(X,U) function
    methods (Test)
        function testEmptyState(testCase)
            % Test for the EmptyStateData error
            X = [];
            U = [];
            errorId = 'testDataInput:EmptyStateData';
            testCase.verifyError(@() testCase.func(X,U), errorId);
        end
        
        function testNoArguments(testCase)
            % Test providing no arguments
            errorId = 'MATLAB:minrhs';
            testCase.verifyError(@() testCase.func(), errorId);
        end
        
        function testInvalidDataSize(testCase)
            % Test invalid data dimensions
            A = [0 0 0 0 0];
            B = 0;
            errorId = 'testDataInput:InconsistentLengthData';
            testCase.verifyError(@() testCase.func(A,B), errorId);
            testCase.verifyError(@() testCase.func(B,A), errorId);
        end
        
        function testNonNummericXU(testCase)
            % Test non numeric input X 
            A = 'not a matrix';
            B = [];
            errorId = 'testDataInput:NonNumericArgument';
            testCase.verifyError(@() testCase.func(A,B), errorId);
            testCase.verifyError(@() testCase.func(B,A), errorId);
        end
    end
end

